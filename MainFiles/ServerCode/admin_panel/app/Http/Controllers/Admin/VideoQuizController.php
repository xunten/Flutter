<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Exports\VideoQuestionExport;
use App\Imports\VideoQuestionImport;
use App\Models\Category;
use App\Models\Video_Leaderborad;
use App\Models\Common;
use App\Models\Video_Question;
use Illuminate\Http\Request;
use Validator;
use DB;
use Illuminate\Support\Facades\Auth;
use Maatwebsite\Excel\Facades\Excel;
use Exception;

class VideoQuizController extends Controller
{
    private $folder = "video_question";
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

                        $data = Video_Question::where('question', 'LIKE', "%{$input_search}%")
                            ->where('category_id', $input_category)->with('category')->latest()->get();
                    } else {

                        $data = Video_Question::where('question', 'LIKE', "%{$input_search}%")->with('category')->latest()->get();
                    }
                } else {

                    if ($input_category != 0) {
                        $data = Video_Question::where('category_id', $input_category)->with('category')->latest()->get();
                    } else {
                        $data = Video_Question::with('category')->latest()->get();
                    }
                }

                // Image Name to URL
                $this->common->imageNameToUrl($data, 'image', $this->folder);

                foreach ($data as $key => $value) {

                    if ($value->video_type == "server_video") {
                        $value['video'] = $this->common->Get_Image($this->folder, $value['video']);
                    }
                }

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = '<form onsubmit="return confirm(\'Are you sure !!! You want to Delete this Question ?\');" method="POST"  action="' . route('videoquestion.destroy', [$row->id]) . '">
                                <input type="hidden" name="_token" value="' . csrf_token() . '">
                                <input type="hidden" name="_method" value="DELETE">
                                <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';

                        $btn = '<div class="d-flex justify-content-around" title="Edit">';
                        $btn .= '<a href="' . route('videoquestion.edit', [$row->id]) . '" class="edit-delete-btn mr-2">';
                        $btn .= '<i class="fa-solid fa-pen-to-square fa-xl"></i>';
                        $btn .= '</a>';
                        $btn .= $delete;
                        $btn .= '</a></div>';
                        return $btn;
                    })
                    ->addColumn('video', function ($row) {
                        if ($row->video_type == "server_video") {
                            $btn = '<a class="btn btn-link video" data-toggle="modal" data-target="#videoModal" data-video="' . $row->video . '" data-image="' . $row->image . '" data-type="' . $row->video_type . '">Server Video</a>';
                        } else {
                            $btn = '<a class="btn text-gray" onclick="return alert(\'Will not play as external URL.\')">External URL</a>';
                        }
                        return $btn;
                    })
                    ->rawColumns(['action', 'video'])
                    ->make(true);
            }
            return view('admin.video_quiz.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function create()
    {
        try {
            $params['category'] = Category::latest()->get();

            return view('admin.video_quiz.add', $params);
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
            if ($request->video_type == "server_video") {
                $validator1 = Validator::make($request->all(), [
                    'video' => 'required|file|mimes:mp4|max:5120',
                ]);
            } else {
                $validator1 = Validator::make($request->all(), [
                    'video_url' => 'required',
                ]);
            }
            if ($validator1->fails()) {
                $errs1 = $validator1->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs1));
            }

            $question = new Video_Question();
            $question->category_id = $request->category_id;
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

            // Video File
            $question->video_type = $request->video_type;
            if ($request->video_type == "server_video") {
                if (isset($request->video)) {
                    $files1 = $request->video;
                    $question->video = $this->common->saveImage($files1, $this->folder);
                } else {
                    $question->video = "";
                }
            } else {
                $question->video = $request->video_url;
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
            $params['result'] = Video_Question::where('id', $id)->first();
            if ($params['result'] != null) {

                $this->common->imageNameToUrl(array($params['result']), 'image', $this->folder);

                $params['category'] = Category::latest()->get();

                return view('admin.video_quiz.edit', $params);
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
            if ($request->video_type == "server_video") {
                $validator1 = Validator::make($request->all(), [
                    'video' => 'file|mimes:mp4|max:5120',
                ]);
            } else {
                $validator1 = Validator::make($request->all(), [
                    'video_url' => 'required',
                ]);
            }
            if ($validator1->fails()) {
                $errs1 = $validator1->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs1));
            }

            $question = Video_Question::where('id', $request->id)->first();
            if (isset($question->id)) {

                $question->category_id = $request->category_id;
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
                // Video
                $question->video_type = $request->video_type;
                if ($request->video_type == "server_video") {

                    if ($request->video_type == $request->old_video_type) {
                        if ($request->video) {

                            $files = $request->video;
                            $question->video = $this->common->saveImage($files, $this->folder);

                            $this->common->deleteImageToFolder($this->folder, $request->old_video);
                        }
                    } else {
                        if ($request->video) {

                            $files = $request->video;
                            $question->video = $this->common->saveImage($files, $this->folder);

                            $this->common->deleteImageToFolder($this->folder, $request->old_video);
                        } else {
                            $question->video = "";
                        }
                    }
                } else {
                    $question->video = $request->video_url;
                    $this->common->deleteImageToFolder($this->folder, $request->old_video);
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

            $question = Video_Question::where('id', $id)->first();
            if (isset($question)) {
                $this->common->deleteImageToFolder($this->folder, $question['image']);
                $this->common->deleteImageToFolder($this->folder, $question['video']);
                $question->delete();
            }
            return redirect()->route('videoquestion.index')->with('success', __('Label.Question Delete Successfully.'));
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // Import Export 
    public function export(Request $request)
    {
        try {
            return Excel::download(new VideoQuestionExport, 'Data-Format-Video.csv');
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

                Excel::import(new VideoQuestionImport, $request->file('import_file'));
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
                    $data = Video_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))->whereDate('created_at', date('Y-m-d'));
                } else if ($input_type == "month") {
                    $data = Video_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'));
                } else if ($input_type == "year") {
                    $data = Video_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'))->whereYear('created_at', date('Y'));
                } else {
                    $data = Video_Leaderborad::select('user_id', DB::raw('SUM(score) As total_score'), DB::raw('RANK() OVER (ORDER BY total_score DESC) as rank'));
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
            return view('admin.video_quiz.leaderboard', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
