<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Exports\TrueFalseQuestionExport;
use App\Imports\TrueFalseQuestionImport;
use App\Models\Category;
use App\Models\TrueFalse_Leaderborad;
use App\Models\Common;
use App\Models\TrueFalse_Question;
use Illuminate\Http\Request;
use Validator;
use DB;
use Illuminate\Support\Facades\Auth;
use Maatwebsite\Excel\Facades\Excel;
use Exception;

class TrueFalseQuizController extends Controller
{
    private $folder = "true_false_question";
    private $folder1 = "user";
    public $common;
    public function __construct()
    {
        $this->common = new Common;
    }

    public function index(Request $request)
    {
        try {
            $params['data'] = [];
            $params['category'] = Category::latest()->get();

            if ($request->ajax()) {

                $input_search = $request['input_search'];
                $input_category = $request['input_category'];

                if ($input_search != null && isset($input_search)) {

                    if ($input_category != 0) {
                        $data = TrueFalse_Question::where('question', 'LIKE', "%{$input_search}%")
                            ->where('category_id', $input_category)->with('category')->latest()->get();
                    } else {
                        $data = TrueFalse_Question::where('question', 'LIKE', "%{$input_search}%")->with('category')->latest()->get();
                    }
                } else {
                    if ($input_category != 0) {
                        $data = TrueFalse_Question::where('category_id', $input_category)->with('category')->latest()->get();
                    } else {
                        $data = TrueFalse_Question::with('category')->latest()->get();
                    }
                }

                // Image Name to URL
                $this->common->imageNameToUrl($data, 'image', $this->folder);

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = '<form onsubmit="return confirm(\'Are you sure !!! You want to Delete this Question ?\');" method="POST"  action="' . route('truefalsequestion.destroy', [$row->id]) . '">
                                <input type="hidden" name="_token" value="' . csrf_token() . '">
                                <input type="hidden" name="_method" value="DELETE">
                                <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';

                        $btn = '<div class="d-flex justify-content-around" title="Edit">';
                        $btn .= '<a href="' . route('truefalsequestion.edit', [$row->id]) . '" class="edit-delete-btn mr-2">';
                        $btn .= '<i class="fa-solid fa-pen-to-square fa-xl"></i>';
                        $btn .= '</a>';
                        $btn .= $delete;
                        $btn .= '</a></div>';
                        return $btn;
                    })
                    ->rawColumns(['action'])
                    ->make(true);
            }
            return view('admin.true_false_quiz.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function create()
    {
        try {
            $params['category'] = Category::latest()->get();

            return view('admin.true_false_quiz.add', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'category_id' => 'required',
                'question' => 'required',
                'image' => 'image|mimes:jpeg,png,jpg|max:2048',
                'option_a' => 'required',
                'option_b' => 'required',
                'answer' => 'required',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $question = new TrueFalse_Question();
            $question->category_id = $request->category_id;
            $question->question = $request->question;
            $question->option_a = $request->option_a;
            $question->option_b = $request->option_b;
            $question->answer = $request->answer;
            $question->note = isset($request->note) ? $request->note : "";
            // Image
            $question->image = "";
            if (isset($request->image)) {
                $files = $request->image;
                $question->image = $this->common->saveImage($files, $this->folder);
            }

            if ($question->save()) {
                return response()->json(array('status' => 200, 'success' => __('Label.success_add_question')));
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.error_add_question')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function edit($id)
    {
        try {
            $params['result'] = TrueFalse_Question::where('id', $id)->first();
            if ($params['result'] != null) {

                $this->common->imageNameToUrl(array($params['result']), 'image', $this->folder);

                $params['category'] = Category::latest()->get();

                return view('admin.true_false_quiz.edit', $params);
            } else {
                return redirect()->back()->with('error', __('Label.page_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function update(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'category_id' => 'required',
                'question' => 'required',
                'image' => 'image|mimes:jpeg,png,jpg|max:2048',
                'option_a' => 'required',
                'option_b' => 'required',
                'answer' => 'required',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $question = TrueFalse_Question::where('id', $request->id)->first();
            if (isset($question->id)) {

                $question->category_id = $request->category_id;
                $question->question = $request->question;
                $question->option_a = $request->option_a;
                $question->option_b = $request->option_b;
                $question->answer = $request->answer;
                $question->note = isset($request->note) ? $request->note : "";
                // Image
                if (isset($request->image)) {
                    $files = $request->image;
                    $question->image = $this->common->saveImage($files, $this->folder);
                    $this->common->deleteImageToFolder($this->folder, basename($request->old_image));
                }

                if ($question->save()) {
                    return response()->json(array('status' => 200, 'success' => __('Label.success_edit_question')));
                } else {
                    return response()->json(array('status' => 400, 'errors' => __('Label.error_edit_question')));
                }
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function destroy($id)
    {
        try {

            $question = TrueFalse_Question::where('id', $id)->first();
            if (isset($question)) {
                $this->common->deleteImageToFolder($this->folder, $question['image']);
                $question->delete();
            }
            return redirect()->route('truefalsequestion.index')->with('success', __('Label.Question Delete Successfully.'));
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // Import Export 
    public function export(Request $request)
    {
        try {
            return Excel::download(new TrueFalseQuestionExport, 'Data-Format-True-False.csv');
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function import(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $validator = Validator::make($request->all(), [
                    'import_file' => 'required|mimes:csv,txt',
                ]);
                if ($validator->fails()) {
                    $errs = $validator->errors()->all();
                    return response()->json(array('status' => 400, 'errors' => $errs));
                }

                Excel::import(new TrueFalseQuestionImport, $request->file('import_file'));
                return response()->json(array('status' => 200, 'success' => "File Upload Successfully"));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // Leaderboard
    public function leaderboard(Request $request)
    {
        try {
            $params['data'] = [];
            if ($request->ajax()) {

                $input_type = $request['input_type'];

                if ($input_type == "today") {
                    $data = TrueFalse_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))->whereDate('created_at', date('Y-m-d'));
                } else if ($input_type == "month") {
                    $data = TrueFalse_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'));
                } else if ($input_type == "year") {
                    $data = TrueFalse_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))->whereYear('created_at', date('Y'));
                } else {
                    $data = TrueFalse_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'));
                }

                $data = $data->groupBy('user_id')->with('users')->orderBy('total_score', 'DESC')->get();

                foreach ($data as $key => $value) {

                    $value['total_score'] = number_format($value['total_score'], 2);
                    if ($value['users'] != null && isset($value['users'])) {
                        $this->common->imageNameToUrl(array($value['users']), 'profile_img', $this->folder1);
                    }
                }

                return DataTables()::of($data)->addIndexColumn()->make(true);
            }
            return view('admin.true_false_quiz.leaderboard', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
