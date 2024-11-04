<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\One_to_One_challenge;
use App\Models\One_to_One_Leaderboard;
use App\Models\One_to_One_Report;
use App\Models\Question;
use App\Models\Common;
use App\Models\Users;
use DateTime;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Validator;

class OneToOneController extends Controller
{
    public $common;
    private $folder_question = "question";

    public function __construct()
    {
        $this->common = new Common;
    }

    // Create >> Join >> Question >> Save Report >> Leaderboard >> List
    public function create_one_to_one_challenge(Request $request) // Date Formate yyyy-mm-dd
    {
        try {
            $validator = Validator::make($request->all(), [
                'name' => 'required|max:30',
                'category_id' => 'required|numeric',
                'c_user_id' => 'required|numeric',
                'start_date' => 'required|date',
                'end_date' => 'required|date',
                'total_question' => 'required|numeric|min:1|max:20',
                'is_paid' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $name = $request->name;
            $category_id = $request->category_id;
            $c_user_id = $request->c_user_id;
            $start_date = $request->start_date;
            $end_date = $request->end_date;
            $total_question = $request->total_question;
            $is_paid = $request->is_paid;
            $point = 0;
            if ($is_paid == 1) {
                $point = $request->point;
            }

            $chackPoint = Users::where('total_points', '>=', $point)->where('id', $c_user_id)->first();

            if ($chackPoint) {

                // Minus Coin Form User
                $chackPoint->decrement('total_points', $point);

                // Add Challenge
                $model = new One_to_One_challenge();
                $model->room_id = Str::random(8);
                $model->category_id = $category_id;
                $model->name = $name;
                $model->c_user_id = $c_user_id;
                $model->start_date = $start_date;
                $model->end_date = $end_date;
                $model->total_question = $total_question;
                $model->is_paid = $is_paid;
                if ($is_paid == 1) {
                    $model->point = $point;
                }

                $Qus = Question::inRandomOrder()->where('category_id', $category_id)->limit($total_question)->get();

                for ($i = 0; $i < count($Qus); $i++) {
                    $Ids[] = $Qus[$i]['id'];
                }

                $IdList = implode(', ', $Ids);
                $model->question_ids = $IdList;

                if ($model->save()) {

                    $userdata = One_to_One_challenge::where('id', $model->id)->first();

                    // C User Name
                    $c_user_name = Users::where('id', $userdata->c_user_id)->first();
                    $userdata['c_user_name'] = "";
                    $userdata['c_fullname'] = "";
                    if ($c_user_name) {
                        $userdata['c_user_name'] = $c_user_name->username;
                        $userdata['c_fullname'] = $c_user_name->fullname;
                    }
                    // J User Name
                    $j_user_name = Users::select('id', 'username')->where('id', $userdata->j_user_id)->first();
                    $userdata['j_user_name'] = "";
                    $userdata['j_fullname'] = "";
                    if ($j_user_name) {
                        $userdata['j_user_name'] = $j_user_name->username;
                        $userdata['j_fullname'] = $j_user_name->fullname;
                    }
                    // Category Name
                    $category = Category::select('id', 'name')->where('id', $userdata->category_id)->first();
                    $userdata['category'] = "";
                    if ($category) {
                        $userdata['category'] = $category->name;
                    }

                    unset($userdata['question_ids']);
                    return $this->common->API_Response(200,  __('api_msg.Challenge Created Successfully.'), array($userdata));
                } else {
                    return $this->common->API_Response(400,  __('api_msg.data_not_save'));
                }
            } else {
                return $this->common->API_Response(400,  __('api_msg.please_recharge_your_wallet'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    public function join_one_to_one_challenge(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'room_id' => 'required|min:8|max:8',
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $room_id = $request->room_id;
            $user_id = $request->user_id;

            $ChackRoomId = One_to_One_challenge::where('room_id', $room_id)->first();
            if ($ChackRoomId) {

                if ($ChackRoomId->is_full == 0) {

                    if ($ChackRoomId->end_date >= date("Y-m-d H:i:s")) {

                        $chackPoint = Users::where('total_points', '>=', $ChackRoomId->point)->where('id', $user_id)->first();

                        if ($chackPoint) {

                            // Minus Coin Form Join User
                            $chackPoint->decrement('total_points', $ChackRoomId->point);

                            // Update Challenge Tbl
                            $ChackRoomId->j_user_id = $user_id;
                            $ChackRoomId->is_full = 1;
                            $ChackRoomId->save();

                            return $this->common->API_Response(200,  __('api_msg.record_add_successfully'), []);
                        } else {
                            return $this->common->API_Response(400,  __('api_msg.please_recharge_your_wallet'));
                        }
                    } else {
                        return $this->common->API_Response(400,  __('api_msg.Challenge is Over.'));
                    }
                } else {
                    return $this->common->API_Response(400,  __('api_msg.Challenge is Full.'));
                }
            } else {
                return $this->common->API_Response(400,  __('api_msg.Please enter right room id.'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    public function get_question_by_one_to_one_challenge(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'room_id' => 'required|min:8|max:8',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $room_id = $request->room_id;
            $ChackRoomId = One_to_One_challenge::where('room_id', $room_id)->first();

            if ($ChackRoomId) {

                if ($ChackRoomId->is_full != 0) {

                    if ($ChackRoomId->end_date >= date("Y-m-d H:i:s")) {

                        if ($ChackRoomId->start_date <= date("Y-m-d H:i:s")) {

                            $QIds = $ChackRoomId->question_ids;
                            $TQCount = count(explode(", ", $QIds));
                            $id = explode(", ", $QIds);
                            $Question_Result = array();

                            for ($i = 0; $i < $TQCount; $i++) {

                                $Question = Question::where('id', $id[$i])->first();

                                $this->common->imageNameToUrl(array($Question), 'image', $this->folder_question);
                                $Question_Result[] = $Question;
                            }

                            return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $Question_Result);
                        } else {

                            return $this->common->API_Response(400,  __('api_msg.Wait, Challenge is not Started.'));
                        }
                    } else {

                        return $this->common->API_Response(400,  __('api_msg.Challenge is Over.'));
                    }
                } else {
                    return $this->common->API_Response(400,  __('api_msg.Not Join Any Other User In This Challenge.'));
                }
            } else {

                return $this->common->API_Response(400,  __('api_msg.Please enter right room id.'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    public function save_one_to_one_challenge_report(Request $request)
    {
        try {

            $validator = Validator::make($request->all(), [
                'room_id' => 'required|min:8|max:8',
                'user_id' => 'required|numeric',
                'total_question' => 'required|numeric',
                'correct_answers' => 'required|numeric',
                'question_json' => 'required',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $room_id = $request->room_id;
            $user_id = $request->user_id;
            $total_question = $request->total_question;
            $correct_answers = $request->correct_answers;
            $question_json = $request->question_json;

            $ChallengeData = One_to_One_challenge::where('room_id', $room_id)->first();
            if (isset($ChallengeData)) {

                $CheckRecord = One_to_One_Report::where('room_id', $room_id)->count();

                if ($CheckRecord <= 2) {

                    if ($ChallengeData->end_date >= date("Y-m-d H:i:s")) {

                        $model = new One_to_One_Report();
                        $model->room_id = $room_id;
                        $model->user_id = $user_id;
                        $model->total_question = $total_question;
                        $model->correct_answers = $correct_answers;
                        $model->question_json = $question_json;
                        $now = DateTime::createFromFormat('U.u', number_format(microtime(true), 6, '.', ''));
                        $model->date = $now->format("Y-m-d H:i:s.u");

                        if ($model->save()) {

                            $GetReport = One_to_One_Report::where('room_id', $room_id)->take(2)->get();

                            if (count($GetReport) == 1) {

                                $leaderboard = new One_to_One_Leaderboard();
                                $leaderboard->room_id = $room_id;
                                $leaderboard->winning_amount = $ChallengeData->price * 2;
                                $leaderboard->w_user_id = $user_id;
                                $leaderboard->l_user_id = 0;
                                $leaderboard->status = 2;
                                $leaderboard->save();
                            } else if (count($GetReport) == 2) {

                                $leaderboard = One_to_One_Leaderboard::where('room_id', $room_id)->first();
                                if ($leaderboard) {

                                    $leaderboard->room_id = $room_id;
                                    if ($GetReport[0]['correct_answers'] > $GetReport[1]['correct_answers']) {

                                        $leaderboard->w_user_id = $GetReport[0]['user_id'];
                                        $leaderboard->l_user_id = $GetReport[1]['user_id'];
                                        $leaderboard->winning_amount = $ChallengeData->price * 2;
                                        $leaderboard->status = 1;
                                    } else if ($GetReport[0]['correct_answers'] < $GetReport[1]['correct_answers']) {

                                        $leaderboard->w_user_id = $GetReport[1]['user_id'];
                                        $leaderboard->l_user_id = $GetReport[0]['user_id'];
                                        $leaderboard->winning_amount = $ChallengeData->price * 2;
                                        $leaderboard->status = 1;
                                    } else {

                                        if ($GetReport[0]['date'] > $GetReport[1]['date']) {

                                            $leaderboard->w_user_id = $GetReport[1]['user_id'];
                                            $leaderboard->l_user_id = $GetReport[0]['user_id'];
                                            $leaderboard->winning_amount = $ChallengeData->price * 2;
                                            $leaderboard->status = 1;
                                        } else if ($GetReport[0]['date'] < $GetReport[1]['date']) {

                                            $leaderboard->w_user_id = $GetReport[0]['user_id'];
                                            $leaderboard->l_user_id = $GetReport[1]['user_id'];
                                            $leaderboard->winning_amount = $ChallengeData->price * 2;
                                            $leaderboard->status = 1;
                                        } else {

                                            $leaderboard->w_user_id = $GetReport[0]['user_id'];
                                            $leaderboard->l_user_id = $GetReport[1]['user_id'];
                                            $leaderboard->winning_amount = $ChallengeData->price;
                                            $leaderboard->status = 0;
                                        }
                                    }
                                    $leaderboard->save();
                                } else {
                                    return $this->common->API_Response(400,  __('api_msg.data_not_save'));
                                }
                            }
                            return $this->common->API_Response(200,  __('api_msg.record_add_successfully'), []);
                        } else {

                            $data['status'] = 400;
                            $data['message'] = __('api_msg.data_not_save');
                            return $data;
                        }
                    } else {
                        return $this->common->API_Response(400,  __('api_msg.Challenge is Over.'));
                    }
                } else {
                    return $this->common->API_Response(400,  __('api_msg.Challenge is Played, So Please Check Leaderboard.'));
                }
            } else {
                return $this->common->API_Response(400,  __('api_msg.Please enter right room id.'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    public function get_one_to_one_challenge_leaderboard(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'room_id' => 'required|min:8|max:8',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $room_id = $request->room_id;
            $result = One_to_One_Leaderboard::where('room_id', $room_id)->first();

            if ($result) {

                if ($result->status != 2) {

                    // W User Name
                    $w_user_name = Users::where('id', $result->w_user_id)->first();
                    $result['w_user_name'] = "";
                    $result['w_fullname'] = "";
                    if ($w_user_name) {
                        $result['w_user_name'] = $w_user_name->username;
                        $result['w_fullname'] = $w_user_name->fullname;
                    }
                    // L User Name
                    $l_user_name = Users::where('id', $result->l_user_id)->first();
                    $result['l_user_name'] = "";
                    $result['l_fullname'] = "";
                    if ($l_user_name) {
                        $result['l_user_name'] = $l_user_name->username;
                        $result['l_fullname'] = $l_user_name->fullname;
                    }
                    return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $result);
                } else {

                    $ChallengeData = One_to_One_challenge::where('room_id', $room_id)->first();

                    if ($ChallengeData->end_date >= date("Y-m-d H:i:s")) {

                        return $this->common->API_Response(400,  __('api_msg.Not Play Other User In This Challenge.'));
                    } else {

                        if ($result->w_user_id = $ChallengeData['j_user_id']) {
                            $result->l_user_id = $ChallengeData['c_user_id'];
                        } else {
                            $result->l_user_id = $ChallengeData['j_user_id'];
                        }

                        $result->winning_amount = $ChallengeData['price'] * 2;
                        $result->status = 1;

                        if ($result->save()) {

                            $userdata = One_to_One_Leaderboard::where('room_id', $room_id)->first();

                            // W User Name
                            $w_user_name = Users::select('id', 'username')->where('id', $userdata->w_user_id)->first();
                            $userdata['w_user_name'] = "";
                            $userdata['w_fullname'] = "";
                            if ($w_user_name) {
                                $userdata['w_user_name'] = $w_user_name->username;
                                $userdata['w_fullname'] = $w_user_name->fullname;
                            }
                            // L User Name
                            $l_user_name = Users::select('id', 'username')->where('id', $userdata->l_user_id)->first();
                            $userdata['l_user_name'] = "";
                            $userdata['l_fullname'] = "";
                            if ($l_user_name) {
                                $userdata['l_user_name'] = $l_user_name->username;
                                $userdata['l_fullname'] = $l_user_name->fullname;
                            }

                            return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), []);
                        } else {
                            return $this->common->API_Response(400,  __('api_msg.record_not_found'));
                        }
                    }
                    return $this->common->API_Response(400,  __('api_msg.record_not_found'));
                }
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    public function get_one_to_one_challenge_by_user_id(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|numeric',
        ]);
        if ($validator->fails()) {
            return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
        }

        $user_id = $request->user_id;
        $userdata = One_to_One_challenge::where('c_user_id', $user_id)->latest()->get();

        if (!$userdata->isEmpty() && isset($userdata)) {

            for ($i = 0; $i < count($userdata); $i++) {

                // C User Name
                $c_user_name = Users::where('id', $userdata[$i]->c_user_id)->first();
                $userdata[$i]['c_user_name'] = "";
                $userdata[$i]['c_fullname'] = "";
                if ($c_user_name) {
                    $userdata[$i]['c_user_name'] = $c_user_name->username;
                    $userdata[$i]['c_fullname'] = $c_user_name->fullname;
                }

                // J User Name
                $j_user_name = Users::where('id', $userdata[$i]->j_user_id)->first();
                $userdata[$i]['j_user_name'] = "";
                $userdata[$i]['j_fullname'] = "";
                if ($j_user_name) {
                    $userdata[$i]['j_user_name'] = $j_user_name->username;
                    $userdata[$i]['j_fullname'] = $j_user_name->fullname;
                }
            }

            return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $userdata);
        } else {

            return $this->common->API_Response(400,  __('api_msg.record_not_found'));
        }
    }
}
