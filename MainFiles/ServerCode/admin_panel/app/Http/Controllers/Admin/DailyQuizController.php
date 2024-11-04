<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Exports\DailyQuizQuestionExport;
use App\Imports\DailyQuizQuestionImport;
use App\Models\Daily_Quiz_Leaderborad;
use App\Models\Common;
use App\Models\Daily_Quiz_Question;
use Illuminate\Http\Request;
use Validator;
use DB;
use Illuminate\Support\Facades\Auth;
use Maatwebsite\Excel\Facades\Excel;
use Exception;

class DailyQuizController extends Controller
{
    private $folder = "daily_quiz_question";
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
            if ($request->ajax()) {

                $input_search = $request['input_search'];

                if ($input_search != null && isset($input_search)) {
                    $data = Daily_Quiz_Question::where('question', 'LIKE', "%{$input_search}%")->latest()->get();
                } else {
                    $data = Daily_Quiz_Question::latest()->get();
                }

                // Image Name to URL
                $this->common->imageNameToUrl($data, 'image', $this->folder);

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = '<form onsubmit="return confirm(\'Are you sure !!! You want to Delete this Question ?\');" method="POST"  action="' . route('dailyquizquestion.destroy', [$row->id]) . '">
                                <input type="hidden" name="_token" value="' . csrf_token() . '">
                                <input type="hidden" name="_method" value="DELETE">
                                <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';

                        $btn = '<div class="d-flex justify-content-around" title="Edit">';
                        $btn .= '<a href="' . route('dailyquizquestion.edit', [$row->id]) . '" class="edit-delete-btn mr-2">';
                        $btn .= '<i class="fa-solid fa-pen-to-square fa-xl"></i>';
                        $btn .= '</a>';
                        $btn .= $delete;
                        $btn .= '</a></div>';
                        return $btn;
                    })
                    ->rawColumns(['action'])
                    ->make(true);
            }
            return view('admin.daily_quiz.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function create()
    {
        try {
            return view('admin.daily_quiz.add');
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            if ($request->question_type == 2) {
                $validator = Validator::make($request->all(), [
                    'question' => 'required',
                    'image' => 'image|mimes:jpeg,png,jpg|max:2048',
                    'question_type' => 'required',
                    'option_a' => 'required',
                    'option_b' => 'required',
                    'answer' => 'required',
                ]);
            } else {
                $validator = Validator::make($request->all(), [
                    'question' => 'required',
                    'image' => 'image|mimes:jpeg,png,jpg,gif,svg|max:2048',
                    'question_type' => 'required',
                    'option_a' => 'required',
                    'option_b' => 'required',
                    'option_c' => 'required',
                    'option_d' => 'required',
                    'answer' => 'required',
                ]);
            }
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $question = new Daily_Quiz_Question();
            $question->question = $request->question;
            $question->question_type = $request->question_type;
            $question->option_a = $request->option_a;
            $question->option_b = $request->option_b;
            $question->option_c = "";
            $question->option_d = "";
            if ($request->question_type == 1) {
                $question->option_c = $request->option_c;
                $question->option_d = $request->option_d;
            }
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
            $params['result'] = Daily_Quiz_Question::where('id', $id)->first();
            if ($params['result'] != null) {

                $this->common->imageNameToUrl(array($params['result']), 'image', $this->folder);

                return view('admin.daily_quiz.edit', $params);
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
            if ($request->question_type == 2) {
                $validator = Validator::make($request->all(), [
                    'question' => 'required',
                    'image' => 'image|mimes:jpeg,png,jpg|max:2048',
                    'question_type' => 'required',
                    'option_a' => 'required',
                    'option_b' => 'required',
                    'answer' => 'required',
                ]);
            } else {
                $validator = Validator::make($request->all(), [
                    'question' => 'required',
                    'image' => 'image|mimes:jpeg,png,jpg|max:2048',
                    'question_type' => 'required',
                    'option_a' => 'required',
                    'option_b' => 'required',
                    'option_c' => 'required',
                    'option_d' => 'required',
                    'answer' => 'required',
                ]);
            }
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $question = Daily_Quiz_Question::where('id', $request->id)->first();
            if (isset($question->id)) {

                $question->question = $request->question;
                $question->question_type = $request->question_type;
                $question->option_a = $request->option_a;
                $question->option_b = $request->option_b;
                if ($request->question_type == 2) {
                    $question->option_c = "";
                    $question->option_d = "";
                } else {
                    $question->option_c = $request->option_c;
                    $question->option_d = $request->option_d;
                }
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

            $question = Daily_Quiz_Question::where('id', $id)->first();
            if (isset($question)) {

                $this->common->deleteImageToFolder($this->folder, $question['image']);
                $question->delete();
            }
            return redirect()->route('dailyquizquestion.index')->with('success', __('Label.Question Delete Successfully.'));
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // Import Export 
    public function export(Request $request)
    {
        try {
            return Excel::download(new DailyQuizQuestionExport, 'Data-Format-Daily-Quiz.csv');
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

                Excel::import(new DailyQuizQuestionImport, $request->file('import_file'));
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
                    $data = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))->whereDate('created_at', date('Y-m-d'));
                } else if ($input_type == "month") {
                    $data = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'));
                } else if ($input_type == "year") {
                    $data = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))->whereYear('created_at', date('Y'));
                } else {
                    $data = Daily_Quiz_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'));
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
            return view('admin.daily_quiz.leaderboard', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
