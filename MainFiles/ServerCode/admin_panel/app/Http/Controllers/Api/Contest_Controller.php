<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Contest;
use App\Models\Contest_Report;
use App\Models\Question;
use App\Models\Users;
use App\Models\Wallet_Transaction;
use App\Models\Winners;
use App\Models\Common;
use Illuminate\Http\Request;
use Validator;
use Exception;

class Contest_Controller extends Controller
{
    private $folder = "contest";
    private $folder_question = "question";
    private $folder_user = "user";
    public $common;
    public function __construct()
    {
        $this->common = new Common;
    }

    // Get Contest >> Join Contest >> Upcoming Contest >> Question By Contest >> Save Report >> Leaderboard >> Review Question >> Winner
    public function get_contest(Request $request) // list_type = ended, upcoming, live
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'list_type' => 'required',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $return['status'] = 200;
            $return['message'] = __('api_msg.get_record_successfully');
            $currentDateTime = date('Y-m-d H:i:s');
            $data = [];

            if ($request->list_type == 'ended') {
                $data = Contest::where('end_date', '<=', $currentDateTime)->latest()->get();
            } elseif ($request->list_type == 'upcoming') {
                $data = Contest::where('start_date', '>=', $currentDateTime)->latest()->get();
            } elseif ($request->list_type == 'live') {
                $data = Contest::where('start_date', '<=', $currentDateTime)->where('end_date', '>=', $currentDateTime)->latest()->get();
            }

            $this->common->imageNameToUrl($data, 'image', $this->folder);

            for ($i = 0; $i < count($data); $i++) {

                $data[$i]->no_of_left_user = $data[$i]->no_of_user;
                $join_user = Wallet_Transaction::where('contest_id', $data[$i]->id)->count();
                if ($join_user) {
                    $data[$i]->no_of_left_user = ($data[$i]->no_of_user - $join_user);
                }

                $data[$i]->is_buy = 0;
                $isBuy = Wallet_Transaction::where('user_id', $request->user_id)->where('contest_id', $data[$i]->id)->first();
                if ($isBuy) {
                    $data[$i]->is_buy = 1;
                }

                $data[$i]->is_played = 0;
                $isPlayed = Contest_Report::where('user_id', $request->user_id)->where('contest_id', $data[$i]->id)->first();
                if ($isPlayed) {
                    $data[$i]->is_played = 1;
                }
            }

            $return['result'] = $data;

            return $return;
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function join_contest(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'contest_id' => 'required|numeric',
                'point' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $user_id = $request->user_id;
            $contest_id = $request->contest_id;
            $point = $request->point;

            $contest = Contest::where('id', $request->contest_id)->first();
            $JoinUser = Wallet_Transaction::where('contest_id', $request->contest_id)->latest()->get();

            if (count($JoinUser) < $contest->no_of_user) {

                $chackPoint = Users::where('total_points', '>=', $point)->where('id', $user_id)->first();

                if ($chackPoint) {

                    $data = new Wallet_Transaction();
                    $data->user_id = $user_id;
                    $data->contest_id = $contest_id;
                    $data->point = $point;

                    if ($data->save()) {

                        Users::where('id', $user_id)->decrement('total_points', $point);
                    }
                    return $this->common->API_Response(200,  __('api_msg.you_have_successfully_joined'), []);
                } else {
                    return $this->common->API_Response(400,  __('api_msg.please_recharge_your_wallet'));
                }
            } else {
                return $this->common->API_Response(200,  __('api_msg.Contest_is_Full'), []);
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function upcoming_contest(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $user_id = "";
            if ($request->user_id) {
                $user_id = $request->user_id;
            }

            $user = Wallet_Transaction::where('user_id', $user_id)->latest()->get();
            $contest_list = [];
            if (count($user) > 0) {

                for ($i = 0; $i < count($user); $i++) {

                    $contest = Contest::where('id', $user[$i]->contest_id)->where('start_date', '>=', date("Y-m-d H:i:s"))->first();

                    if ($contest) {

                        $isPlayed = Contest_Report::where('user_id', $user[$i]->user_id)->where('contest_id', $user[$i]->contest_id)->first();

                        $contest->is_buy = 1;
                        $contest->is_played = 0;
                        if ($isPlayed && $contest) {
                            $contest->is_played = 1;
                        }
                        $contest_list[] = $contest;
                    }
                }
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $contest_list);
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_question_by_contest(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'contest_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $data = Question::inRandomOrder()->where('contest_id', $request->contest_id)->limit('10')->get();

            if ($data) {

                $this->common->imageNameToUrl($data, 'image', $this->folder_question);
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {

                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), []);
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function save_contest_question_report(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'contest_id' => 'required|numeric',
                'total_questions' => 'required|numeric',
                'questions_attended' => 'required|numeric',
                'correct_answers' => 'required|numeric',
                'question_json' => 'required',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $user_id = $request->user_id;
            $contest_id = $request->contest_id;
            $total_questions = $request->total_questions;
            $questions_attended = $request->questions_attended;
            $correct_answers = $request->correct_answers;
            $question_json = $request->question_json;

            $report = new Contest_Report();
            $report->user_id = $user_id;
            $report->contest_id = $contest_id;
            $report->total_questions = $total_questions;
            $report->questions_attended = $questions_attended;
            $report->correct_answers = $correct_answers;

            $percentage = ($correct_answers * 100) / $total_questions;
            $report->score = $percentage;

            $report->question_json = $question_json;
            $report->status = 1;

            if ($report->save()) {
                return $this->common->API_Response(200,  __('api_msg.thank_you_very_much_for_participate'), []);
            } else {
                return $this->common->API_Response(400,  __('api_msg.data_not_save'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_contest_leaderboard(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'contest_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $user_id = $request->user_id;
            $contest_id = $request->contest_id;

            $winner = Winners::where('contest_id', $contest_id)->first();
            if (!isset($winner)) {
                return $this->common->API_Response(400,  "Please wait, Winner not declared.");
            }

            $contest_leaderboard['status'] = 200;
            $contest_leaderboard['message'] = __('api_msg.get_record_successfully');
            $contest_leaderboard['result'] = [];
            $contest_leaderboard['user'] = [];

            $data = Winners::where('contest_id', $contest_id)->with('users')->orderBy('rank', 'asc')->get();

            for ($i = 0; $i < count($data); $i++) {

                if ($data[$i]['users'] != null && isset($data[$i]['users']) && $data[$i]) {

                    $this->common->imageNameToUrl(array($data[$i]['users']), 'profile_img', $this->folder_user);

                    $users['rank'] = $data[$i]->rank;
                    $users['id'] = $data[$i]->id;
                    $users['contest_id'] = $data[$i]->contest_id;
                    $users['user_id'] = $data[$i]->user_id;
                    $users['score'] = $data[$i]->score;
                    $users['fullname'] = $data[$i]['users']->fullname;
                    $users['profile_img'] = $data[$i]['users']->profile_img;
                    $users['name'] = $data[$i]['users']->username;
                    $users['user_total_score'] = (int) $data[$i]['users']->total_score;
                    $final[] = $users;
                    $contest_leaderboard['result'] = $final;
                }
            }

            $data_user = Winners::with('users')->where('contest_id', $contest_id)->where('user_id', $user_id)->orderBy('rank', 'asc')->first();

            if ($data_user && $data_user != null) {

                $this->common->imageNameToUrl(array($data_user['users']), 'profile_img', $this->folder_user);

                $s_users['rank'] = $data_user->rank;
                $s_users['id'] = $data_user->id;
                $s_users['contest_id'] = $data_user->contest_id;
                $s_users['user_id'] = $data_user->user_id;
                $s_users['score'] = $data_user->score;
                $s_users['fullname'] = $data_user['users']->fullname;
                $s_users['profile_img'] = $data_user['users']->profile_img;
                $s_users['name'] = $data_user['users']->username;
                $s_users['user_total_score'] = (int) $data_user['users']->total_score;
                $s_final[] = $s_users;
                $contest_leaderboard['user'] = $s_final;
            }

            return $contest_leaderboard;
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_review_question_by_contest_id(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'contest_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $user_id = $request->user_id;
            $contest_id = $request->contest_id;

            $winner = Winners::where('contest_id', $contest_id)->first();
            if (!isset($winner)) {
                return $this->common->API_Response(400,  "Please wait, Winner not declared.");
            }

            $Rdata = Contest_Report::where('user_id', $user_id)->where('contest_id', $contest_id)->first();

            if ($Rdata) {

                $data['id'] = $Rdata->id;
                $data['user_id'] = $Rdata->user_id;
                $data['contest_id'] = $Rdata->contest_id;
                $data['total_questions'] = $Rdata->total_questions;
                $data['questions_attended'] = $Rdata->questions_attended;
                $data['correct_answers'] = $Rdata->correct_answers;
                $data['score'] = $Rdata->score;
                $data['status'] = $Rdata->status;
                $contest_name = Contest::where('id', $Rdata->contest_id)->first();
                $data['name'] = "";
                if ($contest_name) {
                    $data['name'] = $contest_name->name;
                }
                $data['created_at'] = $Rdata->created_at;
                $data['updated_at'] = $Rdata->updated_at;

                $Json = json_decode($Rdata->question_json, true);

                $Uquestion = [];
                foreach ($Json as $key => $value) {

                    $question = Question::where('id', $value['id'])->first();

                    if ($question->id == $value['id']) {

                        $this->common->imageNameToUrl(array($question), 'image', $this->folder_question);

                        $question['user_answer'] = $value['user_answer'];
                        $Uquestion[] = $question;
                    }
                }
                $data['question_list'] = $Uquestion;

                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'), []);
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_winner_by_contest(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'contest_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $contest_id = $request->contest_id;

            $data = Winners::where('contest_id', $contest_id)->orderBy('rank', 'asc')->get();

            if ($data) {
                for ($i = 0; $i < count($data); $i++) {
                    $user = Users::where('id', $data[$i]->user_id)->first();
                    if ($user) {
                        $this->common->imageNameToUrl(array($user), 'profile_img', $this->folder_user);

                        $data[$i]->fullname = $user->fullname;
                        $data[$i]->username = $user->username;
                        $data[$i]->profile_img = $user->profile_img;
                    }
                }

                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(400,  "Please wait, Winner not declared.");
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
