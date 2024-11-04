<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Earnpoint_Setting;
use App\Models\General_Setting;
use App\Models\Common;
use App\Models\QuestioLeaderboard;
use App\Models\Audio_Leaderborad;
use App\Models\Video_Leaderborad;
use App\Models\Daily_Quiz_Leaderborad;
use App\Models\TrueFalse_Leaderborad;
use App\Models\Earn_transaction;
use App\Models\Refer_Earn_Transaction;
use App\Models\Users;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Validator;
use DB;
use Exception;

// Login Type : 1= Normal, 2= Goggle, 3= OTP, 4= Apple

class UserController extends Controller
{
    private $folder = "user";
    public $common;
    public function __construct()
    {
        $this->common = new Common;
    }

    public function registration(Request $request)
    {
        try {
            $validation = Validator::make(
                $request->all(),
                [
                    'fullname' => 'required|min:2',
                    'mobile_number' => 'required|numeric|unique:tbl_user,mobile_number',
                    'email' => 'required|email|unique:tbl_user',
                    'password' => 'required|min:4',
                ],
                [
                    'email.required' => __('api_msg.please_enter_required_fields'),
                    'email.unique' => __('api_msg.email_address_already_exists'),
                ]
            );
            if ($validation->fails()) {
                $data['status'] = 400;
                $data['message'] = $validation->errors()->first();
                return $data;
            }

            $user = new Users();

            $email_array = explode('@', $request->email);
            $user->username = $this->common->user_name($email_array[0]);
            $user->fullname = $request->fullname;
            $user->mobile_number = $request->mobile_number;
            $user->email = $request->email;
            $user->password = Hash::make($request->password);
            $user->instagram_url = "";
            $user->facebook_url = "";
            $user->twitter_url = "";
            $user->biodata = $this->common->user_tag_line();
            $user->profile_img = "";
            $user->address = "";
            $user->reference_code = Str::random(8);
            $user->pratice_quiz_score = 0;
            $user->total_score = 0;
            $user->total_points = 0;
            $user->device_token = "";
            if ($request->device_token) {
                $user->device_token = $request->device_token;
            }
            $user->device_type = 0;
            if ($request->device_type) {
                $user->device_type = $request->device_type;
            }
            $user->type = 1;
            $user->parent_reference_code = "";
            if ($request->parent_reference_code) {
                $user->parent_reference_code = $request->parent_reference_code;
            }

            if ($user->save()) {

                if ($request->parent_reference_code) {
                    $user_list = Users::where('reference_code', $request->parent_reference_code)->first();

                    $referUserPoint = Earnpoint_Setting::where('type', 3)->first();

                    if ($user_list && $referUserPoint) {

                        $chack_daily_limit = Refer_Earn_Transaction::where('refered_date', date('Y-m-d'))->where('reference_code', $request->parent_reference_code)->get();
                        $type = General_Setting::get();
                        foreach ($type as $key => $value) {
                            if ($value->key == "daily_refer_limit") {
                                $limit = $value;
                                break;
                            } else {
                                $limit = 0;
                            }
                        }
                        $num = (int) $limit->value;
                        if (count($chack_daily_limit) < $num) {

                            $refer = new Refer_Earn_Transaction();
                            $refer->parent_user_id = $user_list->id;
                            $refer->child_user_id = $user->id;
                            $refer->reference_code = $user_list->reference_code;
                            $refer->parent_user_referred_point = $referUserPoint->value;
                            $refer->child_user_earned_point = $referUserPoint->value;
                            $refer->earn_point_type = $referUserPoint->type;
                            $refer->refered_date = date("Y-m-d");
                            $refer->save();

                            Users::where('id', $user->id)->increment('total_points', $referUserPoint->value);
                            Users::where('id', $user_list->id)->increment('total_points', $referUserPoint->value);
                        }
                    } else {
                        $user->parent_reference_code = "";
                    }
                }

                $userdata = Users::where('id', $user->id)->first();
                $this->common->imageNameToUrl(array($userdata), 'profile_img', $this->folder);

                return $this->common->API_Response(200,  __('api_msg.user_registration_sucessfuly'), array($userdata));
            } else {
                return $this->common->API_Response(400,  __('api_msg.data_not_save'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function login(Request $request)
    {
        try {
            if ($request->type == 3) {

                $validation = Validator::make(
                    $request->all(),
                    [
                        'mobile_number' => 'required|numeric',
                    ],
                    [
                        'mobile_number.required' => __('api_msg.mobile_number_is_required'),
                    ]
                );
            } elseif ($request->type == 2 || $request->type == 4) {

                $validation = Validator::make(
                    $request->all(),
                    [
                        'email' => 'required|email',
                    ],
                    [
                        'email.required' => __('api_msg.email_is_required'),
                    ]
                );
            } elseif ($request->type == 1) {

                $validation = Validator::make(
                    $request->all(),
                    [
                        'email' => 'required|email',
                        'password' => 'required|min:4',
                    ],
                    [
                        'email.required' => __('api_msg.email_is_required'),
                        'password.required' => __('api_msg.password_is_required'),
                    ]
                );
            } else {

                $validation = Validator::make(
                    $request->all(),
                    [
                        'type' => 'required|numeric',
                    ],
                    [
                        'type.required' => __('api_msg.type_is_required'),
                    ]
                );
            }
            if ($validation->fails()) {
                $data['status'] = 400;
                $data['message'] = $validation->errors()->first();
                return $data;
            }

            $type = isset($request->type) ? $request->type : 0;
            $fullname = isset($request->fullname) ? $request->fullname : '';
            $email = isset($request->email) ? $request->email : '';
            $password = isset($request->password) ? Hash::make($request->password) : '';
            $mobile_number = isset($request->mobile_number) ? $request->mobile_number : '';
            $device_type = isset($request->device_type) ? $request->device_type : 0;
            $device_token = isset($request->device_token) ? $request->device_token : '';
            $profile_img = '';
            if (isset($request['profile_img']) && $request['profile_img'] != null) {

                $file = $request->file('profile_img');
                $profile_img = $this->common->saveImage($file, $this->folder);
            }

            // OTP
            if ($type == 3) {

                $user = Users::where('mobile_number', $mobile_number)->latest()->first();
                if (isset($user) && $user != null) {

                    // Update Device Token && Type
                    Users::where('id', $user['id'])->update(['device_token' => $device_token]);
                    Users::where('id', $user['id'])->update(['device_type' => $device_type]);
                    $user['device_type'] = $device_type;
                    $user['device_token'] = $device_token;

                    $this->common->imageNameToUrl(array($user), 'profile_img', $this->folder);
                    $user['user_type'] = "login";

                    return $this->common->API_Response(200, __('api_msg.login_successfully'), array($user));
                } else {

                    $user = new Users();
                    $user->fullname = $fullname;
                    $user->username = $this->common->user_name($mobile_number);
                    $user->email = $email;
                    $user->password = $password;
                    $user->mobile_number = $mobile_number;
                    $user->profile_img = $profile_img;
                    $user->type = 3;
                    $user->instagram_url = "";
                    $user->facebook_url = "";
                    $user->twitter_url = "";
                    $user->biodata = $this->common->user_tag_line();
                    $user->address = "";
                    $user->reference_code = Str::random(8);
                    $user->parent_reference_code = "";
                    $user->pratice_quiz_score = 0;
                    $user->total_score = 0;
                    $user->total_points = 0;
                    $user->device_token = $device_token;
                    $user->device_type = $device_type;

                    if ($user->save()) {

                        $user['profile_img'] = $this->common->Get_Image($this->folder, $user->profile_img);
                        $user['user_type'] = "register";

                        return $this->common->API_Response(200, __('api_msg.login_successfully'), array($user));
                    } else {
                        return $this->common->API_Response(400, __('api_msg.not_register'));
                    }
                }
            }

            // Google || Apple
            if ($type == 2 || $type == 4) {

                $user = Users::where('email', $email)->latest()->first();

                if (isset($user) && $user != null) {

                    // Update Device Token && Type
                    Users::where('id', $user['id'])->update(['device_token' => $device_token]);
                    Users::where('id', $user['id'])->update(['device_type' => $device_type]);
                    $user['device_type'] = $device_type;
                    $user['device_token'] = $device_token;

                    $this->common->imageNameToUrl(array($user), 'profile_img', $this->folder);

                    $user['total_score'] = round($user['total_score']);
                    $user['user_type'] = "login";

                    return $this->common->API_Response(200, __('api_msg.login_successfully'), array($user));
                } else {

                    $email_array = explode('@', $email);

                    $user = new Users();
                    $user->fullname = $fullname;
                    $user->username = $this->common->user_name($email_array[0]);
                    $user->mobile_number = $mobile_number;
                    $user->email = $email;
                    $user->password = $password;
                    $user->instagram_url = "";
                    $user->facebook_url = "";
                    $user->twitter_url = "";
                    $user->biodata = $this->common->user_tag_line();
                    $user->address = "";
                    $user->parent_reference_code = "";
                    $user->reference_code = Str::random(8);
                    $user->pratice_quiz_score = 0;
                    $user->total_score = 0;
                    $user->total_points = 0;
                    $user->device_token = $device_token;
                    $user->device_type = $device_type;
                    $user->type = $type;
                    $user->profile_img = $profile_img;

                    if ($user->save()) {

                        $user['profile_img'] = $this->common->Get_Image($this->folder, $user->profile_img);
                        $user['user_type'] = "register";

                        // Send Mail (Type = 1- Register Mail, 2 Transaction Mail)
                        if ($type == 2) {
                            $this->common->Send_Mail(1, $user->email);
                        }

                        return $this->common->API_Response(200, __('api_msg.registration_sucessfully'), array($user));
                    } else {
                        return $this->common->API_Response(400, __('api_msg.data_not_save'));
                    }
                }
            }

            // Normal
            if ($type == 1) {

                $user = Users::where('email', $email)->latest()->first();
                if (isset($user)) {

                    if (Hash::check($request->password, $user->password)) {

                        // Update Device Token && Type
                        Users::where('id', $user['id'])->update(['device_token' => $device_token]);
                        Users::where('id', $user['id'])->update(['device_type' => $device_type]);
                        $user['device_type'] = $device_type;
                        $user['device_token'] = $device_token;

                        $user['user_type'] = "login";
                        $user['total_score'] = round($user['total_score']);

                        $this->common->imageNameToUrl(array($user), 'profile_img', $this->folder);

                        return $this->common->API_Response(200, 'Login Successfully.', array($user));
                    } else {
                        return $this->common->API_Response(400, __('api_msg.username_and_pasword_is_wrong'));
                    }
                } else {
                    return $this->common->API_Response(400, __('api_msg.username_and_pasword_is_wrong'));
                }
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function profile(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400, __('api_msg.please_enter_required_fields'));
            }

            $user_id = $request->user_id;
            $data = Users::where('id', $request->user_id)->first();

            if ($data != null && isset($data)) {

                $data->total_score = round($data->total_score);
                $this->common->imageNameToUrl(array($data), 'profile_img', $this->folder);

                $data->player_bedge = "Silver";
                if ($data->total_points >= 1000) {
                    $data->player_bedge = "Gold";
                }
                if ($data->total_points >= 10000) {
                    $data->player_bedge = "Platinum";
                }

                // Rank
                $data->rank = 0;
                $result = Users::select(DB::raw(' RANK() OVER (ORDER BY total_points DESC) as `rank`'), 'id', 'total_points')->where('total_points', '!=', '0')->orderBy('rank', 'ASC')->get();
                for ($i = 0; $i < count($result); $i++) {

                    if ($user_id == $result[$i]['id']) {
                        $data->rank = $result[$i]['rank'];
                        break;
                    }
                }

                // Total Played Quiz
                $normal_quiz = QuestioLeaderboard::where('user_id', $user_id)->count();
                $audio_quiz = Audio_Leaderborad::where('user_id', $user_id)->count();
                $video_quiz = Video_Leaderborad::where('user_id', $user_id)->count();
                $true_false_quiz = TrueFalse_Leaderborad::where('user_id', $user_id)->count();
                $daily_quiz = Daily_Quiz_Leaderborad::where('user_id', $user_id)->count();
                $data->total_played_quiz = $normal_quiz + $audio_quiz + $video_quiz + $true_false_quiz + $daily_quiz;

                // Total Earn Point
                $total_eran_points = Earn_transaction::where('user_id', $user_id)->where('contest_id', 0)->where('type', '!=', 1)->sum('point');
                $data->total_points_earned = $total_eran_points;

                // Total Attend Question
                $normal_attend_qus = QuestioLeaderboard::where('user_id', $user_id)->sum('questions_attended');
                $audio_attend_qus = Audio_Leaderborad::where('user_id', $user_id)->sum('questions_attended');
                $video_attend_qus = Video_Leaderborad::where('user_id', $user_id)->sum('questions_attended');
                $true_false_attend_qus = TrueFalse_Leaderborad::where('user_id', $user_id)->sum('questions_attended');
                $daily_attend_qus = Daily_Quiz_Leaderborad::where('user_id', $user_id)->sum('questions_attended');
                $data->total_attended_question = $normal_attend_qus + $audio_attend_qus + $video_attend_qus + $true_false_attend_qus + $daily_attend_qus;

                // Total Correct Question
                $normal_correct_qus = QuestioLeaderboard::where('user_id', $user_id)->sum('correct_answers');
                $audio_correct_qus = Audio_Leaderborad::where('user_id', $user_id)->sum('correct_answers');
                $video_correct_qus = Video_Leaderborad::where('user_id', $user_id)->sum('correct_answers');
                $true_false_correct_qus = TrueFalse_Leaderborad::where('user_id', $user_id)->sum('correct_answers');
                $daily_correct_qus = Daily_Quiz_Leaderborad::where('user_id', $user_id)->sum('correct_answers');
                $data->total_correct_question = $normal_correct_qus + $audio_correct_qus + $video_correct_qus + $true_false_correct_qus + $daily_correct_qus;

                return $this->common->API_Response(200, __('api_msg.get_record_successfully'), array($data));
            } else {
                return $this->common->API_Response(400, __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function update_profile(Request $request)
    {
        try {
            $validation = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validation->fails()) {

                return $this->common->API_Response(400, __('api_msg.please_enter_required_fields'));
            }

            $data = Users::where('id', $request->user_id)->first();
            if ($data) {
                if ($request->fullname) {
                    $data->fullname = $request->fullname;
                }
                if (isset($request->username) && $request->username != '') {

                    $check = Users::where('username', $request->username)->first();
                    if (isset($check) && $check != null) {
                        if ($check->id == $data->id) {
                            $data->username = $request->username;
                        } else {
                            return $this->common->API_Response(400, __('api_msg.username_exists'));
                        }
                    } else {
                        $data->username = $request->username;
                    }
                }
                if ($request->instagram_url) {
                    $data->instagram_url = $request->instagram_url;
                }
                if ($request->facebook_url) {
                    $data->facebook_url = $request->facebook_url;
                }
                if ($request->twitter_url) {
                    $data->twitter_url = $request->twitter_url;
                }
                if ($request->biodata) {
                    $data->biodata = $request->biodata;
                }
                if ($request->file('profile_img')) {

                    $files = $request['profile_img'];
                    $old_img_name = $data['profile_img'];
                    $data['profile_img'] = $this->common->saveImage($files, $this->folder);

                    $this->common->deleteImageToFolder($this->folder, $old_img_name);
                }
                if ($request->email) {
                    $data->email = $request->email;
                }
                if (isset($request->password) && $request->password != '') {
                    $data->password = hash::make($request->password);
                }
                if ($request->mobile_number) {
                    $data->mobile_number = $request->mobile_number;
                }
                if (isset($request->device_type) && $request->device_type != '') {
                    $data->device_type = $request->device_type;
                }
                if (isset($request->device_token) && $request->device_token != '') {
                    $data->device_token = $request->device_token;
                }

                if ($data->save()) {

                    $data->total_score = round($data->total_score);
                    $this->common->imageNameToUrl(array($data), 'profile_img', $this->folder);

                    $data->player_bedge = "Silver";
                    if ($data->total_points >= 1000) {
                        $data->player_bedge = "Gold";
                    }
                    if ($data->total_points >= 10000) {
                        $data->player_bedge = "Platinum";
                    }

                    return $this->common->API_Response(200, __('api_msg.update_sucessfuly'), array($data));
                } else {
                    return $this->common->API_Response(400, __('api_msg.update_sucessfuly'));
                }
            } else {
                return $this->common->API_Response(400, __('api_msg.no_record'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
