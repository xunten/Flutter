<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Contest;
use App\Models\Contest_Report;
use App\Models\Level;
use App\Models\Common;
use App\Models\Question;
use App\Models\Wallet_Transaction;
use App\Models\Winners;
use DB;
use Illuminate\Http\Request;
use Validator;
use Exception;

class ContestController extends Controller
{
    private $folder = "contest";
    private $folder_user = "user";
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
                    $data = Contest::where('name', 'LIKE', "%{$input_search}%")->latest()->get();
                } else {
                    $data = Contest::latest()->get();
                }

                for ($i = 0; $i < count($data); $i++) {
                    $JoinUserCount = Wallet_Transaction::where('contest_id', $data[$i]->id)->count();
                    $data[$i]->total_participants_user = $JoinUserCount;
                }

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = '<form onsubmit="return confirm(\'Are you sure !!! You want to Delete this Contest ?\');" method="POST"  action="' . route('contests.destroy', [$row->id]) . '">
                                <input type="hidden" name="_token" value="' . csrf_token() . '">
                                <input type="hidden" name="_method" value="DELETE">
                                <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';

                        $btn = '<div class="d-flex justify-content-around" title="Edit">';
                        $btn .= '<a href="' . route('contests.edit', [$row->id]) . '" class="edit-delete-btn mr-2">';
                        $btn .= '<i class="fa-solid fa-pen-to-square fa-xl"></i>';
                        $btn .= '</a>';
                        $btn .= $delete;
                        $btn .= '</a></div>';
                        return $btn;
                    })
                    ->addColumn('winner', function ($row) {
                        if ($row->end_date >= date("Y-m-d h:i:s")) {
                            $btn = '<a href="" class="btn text-white p-1" style="background:#ff9700;font-size:14px;font-weight: bold;"> NOT ENDED</a> ';
                            return $btn;
                        } else {
                            $chack = Winners::where('contest_id', $row->id)->get();
                            if (count($chack)) {
                                $btn = '<a href="' . route("contestleaderboard", $row->id) . '" class="btn js-click text-white p-1" style="background:#15ca20; font-size:14px;font-weight: bold;">  WINNER LIST </a> ';
                            } else {
                                $btn = '<a href="' . route("contest_makewinner", $row->id) . '" class="btn js-click text-white p-1" style="background:#0dceec; font-size:14px;font-weight: bold;">  MAKE WINNER </a> ';
                            }
                            return $btn;
                        }
                    })
                    ->rawColumns(['action', 'winner'])
                    ->make(true);
            }
            return view('admin.contest.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function create()
    {
        try {
            $contest = Level::latest()->get();
            return view('admin.contest.add', ['result' => $contest]);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'level_id' => 'required',
                'name' => 'required|min:2',
                'start_date' => 'required',
                'end_date' => 'required|after:start_date',
                'image' => 'required|image|mimes:jpeg,png,jpg|max:2048',
                'price' => 'required|numeric|min:0',
                'no_of_user' => 'required|numeric|min:0',
                'no_of_user_prize' => 'required|numeric|min:0',
                'no_of_rank' => 'required|numeric|max:10|min:0',
                'total_prize' => 'required|numeric|min:0',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $contest = new Contest();
            $contest->level_id = $request->level_id;
            $contest->name = $request->name;
            $contest->start_date = $request->start_date;
            $contest->end_date = $request->end_date;
            $contest->price = $request->price;
            $contest->no_of_user = $request->no_of_user;
            $contest->no_of_user_prize = $request->no_of_user_prize;
            $contest->no_of_rank = $request->no_of_rank;
            $contest->total_prize = $request->total_prize;
            $contest->prize_json = $this->get_prize_list($request->no_of_rank, $request->no_of_user_prize, $request->total_prize);
            $contest->status = 1;
            $contest->type = 0;

            if (isset($request->image)) {

                $files = $request->image;
                $contest->image = $this->common->saveImage($files, $this->folder);
            }

            if ($contest->save()) {
                return response()->json(array('status' => 200, 'success' => __('Label.success_add_contest')));
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.error_add_contest')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function edit($id)
    {
        try {
            $params['result'] = Contest::where('id', $id)->first();
            if ($params['result'] != null) {

                $this->common->imageNameToUrl(array($params['result']), 'image', $this->folder);

                $params['level'] = Level::latest()->get();

                return view('admin.contest.edit', $params);
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
                'level_id' => 'required',
                'name' => 'required|min:2',
                'start_date' => 'required',
                'end_date' => 'required|after:start_date',
                'price' => 'required|numeric',
                'no_of_user' => 'required|numeric',
                'no_of_user_prize' => 'required|numeric',
                'no_of_rank' => 'required|numeric|max:10',
                'total_prize' => 'required|numeric',
                'image' => 'image|mimes:jpeg,png,jpg|max:2048',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $contest = Contest::where('id', $request->id)->first();
            if (isset($contest->id)) {
                $contest->level_id = $request->level_id;
                $contest->name = $request->name;
                $contest->start_date = $request->start_date;
                $contest->end_date = $request->end_date;
                $contest->price = $request->price;
                $contest->no_of_user = $request->no_of_user;
                $contest->no_of_user_prize = $request->no_of_user_prize;
                $contest->no_of_rank = $request->no_of_rank;
                $contest->total_prize = $request->total_prize;
                $contest->prize_json = $this->get_prize_list($request->no_of_rank, $request->no_of_user_prize, $request->total_prize);
                $contest->status = 1;
                $contest->type = 0;

                if (isset($request->image)) {
                    $files = $request->image;
                    $contest->image = $this->common->saveImage($files, $this->folder);

                    $this->common->deleteImageToFolder($this->folder, basename($request->old_image));
                }

                if ($contest->save()) {
                    return response()->json(array('status' => 200, 'success' => __('Label.success_edit_contest')));
                } else {
                    return response()->json(array('status' => 400, 'errors' => __('Label.error_edit_contest')));
                }
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function destroy($id)
    {
        try {
            $contest = Contest::where('id', $id)->first();
            $question = Question::where('contest_id', $id)->first();

            if ($question !== null) {
                return back()->with('error', __('Label.This Contest is used on some other table so you can not remove it.'));
            }

            if (isset($contest)) {
                $this->common->deleteImageToFolder($this->folder, $contest['image']);
                $contest->delete();
            }
            return redirect()->route('contests.index')->with('success', "Contest Delete SuccessFully.");
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // Price Json
    public function get_prize_list($no_of_rank = '10', $no_user_user = null, $total_amount = null)
    {
        try {
            if ($no_user_user <= 10 && $no_user_user == $no_of_rank) {
                $new_rank = $no_of_rank;
                $new_user_user = $no_user_user;
                $range_new = round($new_user_user / $new_rank);
            } else if ($no_of_rank > 3) {
                $new_rank = $no_of_rank - 3;
                $new_user_user = $no_user_user - 3;
                $range_new = round($new_user_user / $new_rank);
            }

            $pecent = 100;
            $ranges = [100, 75, 70, 65, 60, 55, 50, 45, 40, 35];
            $range = $ranges[$no_of_rank - 1];
            $sum = 0;

            $row = [];
            $range_new1 = 0;
            $is_stop = 0;
            for ($i = 0; $i < $no_of_rank; $i++) {
                $per = ($pecent * $range) / 100;
                $pecent -= round($per);
                $sum += round($per);
                $data = [];
                $data['percentage'] = number_format($per, 2);
                $data['winning_amount'] = ($total_amount * $per) / 100;
                if ($i > 2) {
                    if ($i == 3) {
                        $range_new1 = $i + 1;
                    }

                    if ($no_user_user == $new_rank) {
                        $data['rank'] = $i + 1;
                    } else if ($no_user_user < ($range_new1 + $range_new)) {
                        $data['rank'] = $range_new1 . ' to ' . $no_user_user;
                        $is_stop = 1;
                    } else {
                        $data['rank'] = $range_new1 . ' to ' . ($range_new1 + $range_new);
                    }
                    $range_new1 += $range_new + 1;
                } else {
                    $range_new1 = $i + 1;
                    $data['rank'] = number_format($i + 1, 0);
                }

                $row[] = $data;
                if ($is_stop == 1) {
                    break;
                }
            }

            $array['win_list'] = $row;
            // p($array);
            return json_encode($array);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // Make Winner
    public function make_winner($contestId)
    {
        try {

            $contestData = Contest::where('id', $contestId)->first();
            if (isset($contestData['id']) && $contestData['id'] != '') {

                $rank = Contest_Report::select(DB::raw(' RANK() OVER (ORDER BY score DESC) as rank'), 'id', 'score', 'contest_id', 'user_id')
                    ->groupBy('user_id')->where('contest_id', $contestId)->orderBy('rank', 'ASC')->get();

                $winJson = json_decode($contestData['prize_json']);

                $data = [];
                foreach ($winJson->win_list as $row) {
                    $between = explode(' to ', $row->rank);
                    if (count($between) > 1) {
                        $rowData = $row;
                        for ($i = $between[0]; $i <= $between[1]; $i++) {
                            $rowData = [];
                            $rowData['rank'] = $i;
                            $rowData['winning_amount'] = $row->winning_amount;
                            $rowData['percentage'] = $row->percentage;
                            $data[] = $rowData;
                        }
                    } else {
                        $rowData = [];
                        $rowData['rank'] = $between[0];
                        $rowData['winning_amount'] = $row->winning_amount;
                        $rowData['percentage'] = $row->percentage;
                        $data[] = $rowData;
                    }
                }

                $winnList = array();
                foreach ($rank as $key => $usersData) {
                    $data[$key]['score'] = $usersData['score'];
                    $data[$key]['user_id'] = $usersData['user_id'];
                    $data[$key]['contest_id'] = $usersData['contest_id'];
                    $winnList[] = $data[$key];
                }

                Winners::where('contest_id', $contestId)->delete();

                foreach ($winnList as $win) {
                    $winInsert['point'] = $win['winning_amount'];
                    $winInsert['percentage'] = $win['percentage'];
                    $winInsert['rank'] = $win['rank'];
                    $winInsert['score'] = $win['score'];
                    $winInsert['user_id'] = $win['user_id'];
                    $winInsert['contest_id'] = $win['contest_id'];

                    Winners::insert($winInsert);
                }
                return redirect()->route('contests.index');
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // Leaderboard
    public function leaderboard($id, Request $request)
    {
        try {

            $params['data'] = [];
            $params['id'] = $id;
            if ($request->ajax()) {

                $data = Winners::where('contest_id', $id)->orderby('rank', 'asc')->with('users')->get();

                foreach ($data as $key => $value) {

                    if ($value['users'] != null && isset($value['users'])) {
                        $this->common->imageNameToUrl(array($value['users']), 'profile_img', $this->folder_user);
                    }
                }

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->make(true);
            }
            return view('admin.contest.leaderboard', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
