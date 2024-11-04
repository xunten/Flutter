<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Contest;
use App\Models\Common;
use App\Models\Question;
use Illuminate\Http\Request;
use Validator;
use App\Exports\ContestQuestionExport;
use App\Imports\ContestQuestionImport;
use Illuminate\Support\Facades\Auth;
use Maatwebsite\Excel\Facades\Excel;
use Exception;

class ContestQuestionController extends Controller
{
    private $folder = "question";
    public $common;
    public function __construct()
    {
        $this->common = new Common;
    }

    public function index(Request $request)
    {
        try {
            $params['data'] = [];
            $params['contest'] = Contest::latest()->get();

            if ($request->ajax()) {

                $input_search = $request['input_search'];
                $input_contest = $request['input_contest'];

                if ($input_search != null && isset($input_search)) {

                    if ($input_contest != 0) {
                        $data = Question::where('question', 'LIKE', "%{$input_search}%")->where('contest_id', $input_contest)
                            ->with('contest')->where('level_id', 0)->latest()->get();
                    } else {
                        $data = Question::where('question', 'LIKE', "%{$input_search}%")->with('contest')->where('level_id', 0)->latest()->get();
                    }
                } else {

                    if ($input_contest != 0) {
                        $data = Question::where('contest_id', $input_contest)->with('contest')->where('level_id', 0)->latest()->get();
                    } else {
                        $data = Question::with('contest')->where('level_id', 0)->latest()->get();
                    }
                }

                // Image Name to URL
                $this->common->imageNameToUrl($data, 'image', $this->folder);

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = '<form onsubmit="return confirm(\'Are you sure !!! You want to Delete this Question ?\');" method="POST"  action="' . route('contestquestion.destroy', [$row->id]) . '">
                                <input type="hidden" name="_token" value="' . csrf_token() . '">
                                <input type="hidden" name="_method" value="DELETE">
                                <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';

                        $btn = '<div class="d-flex justify-content-around" title="Edit">';
                        $btn .= '<a href="' . route('contestquestion.edit', [$row->id]) . '" class="edit-delete-btn mr-2">';
                        $btn .= '<i class="fa-solid fa-pen-to-square fa-xl"></i>';
                        $btn .= '</a>';
                        $btn .= $delete;
                        $btn .= '</a></div>';
                        return $btn;
                    })
                    ->rawColumns(['action'])
                    ->make(true);
            }
            return view('admin.contest_question.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function create()
    {
        try {
            $params['category'] = Category::latest()->get();
            $params['contest'] = Contest::latest()->get();

            return view('admin.contest_question.add', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            if ($request->question_type == 2) {
                $validator = Validator::make($request->all(), [
                    'category_id' => 'required',
                    'contest_id' => 'required',
                    'question' => 'required',
                    'image' => 'image|mimes:jpeg,png,jpg|max:2048',
                    'question_type' => 'required',
                    'option_a' => 'required',
                    'option_b' => 'required',
                    'answer' => 'required',
                ]);
            } else {
                $validator = Validator::make($request->all(), [
                    'category_id' => 'required',
                    'contest_id' => 'required',
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

            $question = new Question();
            $question->category_id = $request->category_id;
            $question->contest_id = $request->contest_id;
            $question->level_id = 0;
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
            $params['result'] = Question::where('id', $id)->first();
            if ($params['result'] != null) {

                $this->common->imageNameToUrl(array($params['result']), 'image', $this->folder);

                $params['category'] = Category::latest()->get();
                $params['contest'] = Contest::latest()->get();

                return view('admin.contest_question.edit', $params);
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
                    'category_id' => 'required',
                    'contest_id' => 'required',
                    'question' => 'required',
                    'image' => 'image|mimes:jpeg,png,jpg|max:2048',
                    'question_type' => 'required',
                    'option_a' => 'required',
                    'option_b' => 'required',
                    'answer' => 'required',
                ]);
            } else {
                $validator = Validator::make($request->all(), [
                    'category_id' => 'required',
                    'contest_id' => 'required',
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

            $question = Question::where('id', $request->id)->first();
            if (isset($question->id)) {

                $question->category_id = $request->category_id;
                $question->contest_id = $request->contest_id;
                $question->level_id = 0;
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

            $question = Question::where('id', $id)->first();
            if (isset($question)) {
                $this->common->deleteImageToFolder($this->folder, $question['image']);
                $question->delete();
            }
            return redirect()->route('contestquestion.index')->with('success', __('Label.Question Delete Successfully.'));
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // Import Export 
    public function export(Request $request)
    {
        try {
            return Excel::download(new ContestQuestionExport, 'Data-Formate-Contest.csv');
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

                Excel::import(new ContestQuestionImport, $request->file('import_file'));
                return response()->json(array('status' => 200, 'success' => "File Upload Successfully"));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
