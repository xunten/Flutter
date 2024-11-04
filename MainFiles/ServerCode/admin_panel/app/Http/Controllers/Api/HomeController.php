<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Earn_point;
use App\Models\Earnpoint_Setting;
use App\Models\General_Setting;
use App\Models\Notification;
use App\Models\Subscription_Plan;
use App\Models\Transaction;
use App\Models\Users;
use App\Models\Notification_Tracking;
use App\Models\Refer_Earn_Transaction;
use App\Models\Reward_Transaction;
use App\Models\Wallet_Transaction;
use App\Models\Earn_transaction;
use App\Models\Withdrawal;
use App\Models\Contest;
use Illuminate\Http\Request;
use App\Models\Common;
use App\Models\Page;
use App\Models\Payment_Option;
use App\Models\Social_Link;
use Validator;
use Exception;

class HomeController extends Controller
{
    private $folder = "app";
    private $folder_user = "user";
    private $folder_notification = "notification";
    private $folder_package = "subscription";
    public $common;
    public function __construct()
    {
        $this->common = new Common;
    }

    public function genaral_setting()
    {
        try {
            $data = General_Setting::select('id', 'key', 'value')->get();
            if ($data) {

                foreach ($data as $key => $value) {
                    if ($value['key'] == 'app_logo') {
                        $value['value'] = $this->common->Get_Image($this->folder, $value['value']);
                    }
                }
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_pages()
    {
        try {
            $data = Page::get();

            $return['status'] = 200;
            $return['message'] = __('api_msg.get_record_successfully');
            $return['result'] = [];

            for ($i = 0; $i < count($data); $i++) {

                $return['result'][$i]['page_name'] = $data[$i]['page_name'];
                $return['result'][$i]['title'] = $data[$i]['title'];
                $return['result'][$i]['url'] = env('APP_URL') . '/public/admin/pages/' . $data[$i]['id'];
                $return['result'][$i]['icon'] = $this->common->Get_Image($this->folder, $data[$i]['icon']);
            }
            return $return;
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_payment_option()
    {
        try {

            $return['status'] = 200;
            $return['message'] = __('api_msg.get_record_successfully');
            $return['result'] = [];

            $Option_data = Payment_Option::get();
            foreach ($Option_data as $key => $value) {
                $return['result'][$value['name']] = $value;
            }

            return $return;
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_social_link()
    {
        try {
            $Data = Social_Link::latest()->get();
            if (sizeof($Data) > 0) {

                $this->common->imageNameToUrl($Data, 'image', $this->folder);

                return $this->common->APIResponse(200, __('api_msg.get_record_successfully'), $Data);
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function earn_point()
    {
        try {
            $spin_wheel = Earn_point::select('id', 'key', 'value', 'type', 'point_type', 'created_at')->where('point_type', '1')->get();
            $daily_login = Earn_point::select('id', 'key', 'value', 'type', 'point_type', 'created_at')->where('point_type', '2')->get();
            $free_coin = Earn_point::select('id', 'key', 'value', 'type', 'point_type', 'created_at')->where('point_type', '3')->get();

            if ($spin_wheel && $daily_login && $free_coin) {
                $subarray['status'] = 200;
                $subarray['message'] = __('api_msg.get_record_successfully');

                $subarray['spin_wheel'] = $spin_wheel;
                $subarray['daily_login'] = $daily_login;
                $subarray['free_coin'] = $free_coin;

                return $subarray;
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function earn_point_setting()
    {
        try {
            $data = Earnpoint_Setting::select('id', 'key', 'value')->get();
            if ($data) {
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_notification(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $user_noti = Notification_Tracking::where('user_id', $request->user_id)->get();
            $arr = array();
            for ($i = 0; $i < count($user_noti); $i++) {
                $arr[] = $user_noti[$i]->notification_id;
            }

            $data = Notification::whereNotIn('id', $arr)->latest()->get();

            $this->common->imageNameToUrl($data, 'image', $this->folder_notification);

            return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function read_notification(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'notification_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $noti = new Notification_Tracking();
            $noti->user_id = $request->user_id;
            $noti->notification_id = $request->notification_id;

            if ($noti->save()) {
                return $this->common->API_Response(200,  __('api_msg.notification_read_successfully'), []);
            } else {
                return $this->common->API_Response(400,  __('api_msg.notification_not_read'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_packages()
    {
        try {
            $data = Subscription_Plan::latest()->get();
            if ($data) {

                $this->common->imageNameToUrl($data, 'image', $this->folder_package);
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), []);
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_package_transaction(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $msg['status'] = 200;
            $msg['message'] = __('api_msg.get_record_successfully');

            $data = Transaction::where('user_id', $request->user_id)->latest()->get();
            if (count($data)) {

                for ($i = 0; $i < count($data); $i++) {

                    $package_name = Subscription_Plan::where('id', $data[$i]->plan_subscription_id)->first();

                    $data[$i]->package_name = "";
                    if ($package_name) {
                        $data[$i]->package_name = $package_name->name;
                    }
                }
                $msg['result'] = $data;
            } else {
                $msg['result'] = [];
            }
            return $msg;
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function add_package_transaction(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'plan_subscription_id' => 'required|numeric',
                'point' => 'required|numeric',
                'transaction_amount' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $transaction_id = "";
            if ($request->transaction_id) {
                $transaction_id = $request->transaction_id;
            }

            $data = new Transaction();
            $data->user_id = $request->user_id;
            $data->plan_subscription_id = $request->plan_subscription_id;
            $data->transaction_id = $transaction_id;
            $data->transaction_amount = $request->transaction_amount;
            $data->point = $request->point;

            if ($data->save()) {

                Users::where('id', $data->user_id)->increment('total_points', $data->point);

                // Send Mail (Type = 1- Register Mail, 2 Transaction Mail)
                $user = Users::where('id', $request->user_id)->first();
                if (isset($user) && $user != null) {
                    $this->common->Send_Mail(2, $user->email);
                }

                return $this->common->API_Response(200,  __('api_msg.record_add_successfully'), []);
            } else {
                return $this->common->API_Response(400,  __('api_msg.data_not_save'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function withdrawal_request(Request $request)
    {
        try {
            $setting_data = settingData();
            $min_earning_point = $setting_data['min_earning_point'];

            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'payment_detail' => 'required',
                'payment_type' => 'required',
                'point' => 'required|numeric|min:' . $min_earning_point,
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $data = Users::where('id', $request->user_id)->first();

            if ($data) {

                if ($data->total_points >= $min_earning_point) {

                    $withdrawal_req = new Withdrawal();
                    $withdrawal_req->user_id = $request->user_id;
                    $withdrawal_req->point = $data->total_points;
                    $total_amount = $request->point / $min_earning_point;
                    $withdrawal_req->total_amount = round($total_amount);
                    $withdrawal_req->payment_type = $request->payment_type;
                    $withdrawal_req->payment_detail = $request->payment_detail;
                    $withdrawal_req->status = 0;
                    $withdrawal_req->save();

                    $data->total_points = $data->total_points - $request->point;
                    $data->save();

                    return $this->common->API_Response(200,  __('api_msg.your_withdrawal_request_successfully_added'), []);
                } else {
                    $msg['status'] = 201;
                    $msg['message'] = "Your earning points not more than " . $min_earning_point . ".";
                    return $msg;
                }
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function withdrawal_list(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $data = Withdrawal::where('user_id', $request->user_id)->latest()->get();
            if (count($data)) {
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function reward_points(Request $request) // Type 0- Daily, 1- Spin to win
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'reward_points' => 'required|numeric',
                'type' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $user = new Reward_Transaction();
            $user->user_id = $request->user_id;
            $user->reward_points = $request->reward_points;

            $user->type = '0';
            if ($request->type == '1') {
                $user->type = '1';
            }

            if ($user->save()) {

                Users::where('id', $user->user_id)->increment('total_points', $request->reward_points);

                return $this->common->API_Response(200,  __('api_msg.points_rewarded_successfully'));
            } else {
                return $this->common->API_Response(400,  __('api_msg.points_not_save'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function refer_transaction(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $data = Refer_Earn_Transaction::select('*')->where('parent_user_id', $request->user_id)->with('users')->latest()->get();

            if (count($data)) {

                for ($i = 0; $i < count($data); $i++) {

                    $result['parent_user_id'] = $data[$i]->parent_user_id;
                    $result['child_user_id'] = $data[$i]->child_user_id;
                    $result['reference_code'] = $data[$i]->reference_code;
                    $result['refered_point'] = $data[$i]->child_user_earned_point;
                    $result['refered_date'] = $data[$i]->refered_date;

                    $result['fullname'] = "";
                    $result['user_name'] = "";
                    $result['email'] = "";
                    $result['profile_img'] = "";
                    $result['mobile_number'] = "";
                    if ($data[$i]->users) {
                        $result['fullname'] = $data[$i]->users->fullname;
                        $result['user_name'] = $data[$i]->users->username;
                        $result['email'] = $data[$i]->users->email;
                        $result['profile_img'] = $this->common->Get_Image($this->folder_user, $data[$i]->users->profile_img);
                        $result['mobile_number'] = $data[$i]->users->mobile_number;
                    }

                    $store[] = $result;
                }

                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $store);
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_earn_transaction(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $data = Earn_transaction::select('id', 'user_id', 'contest_id', 'type', 'point', 'created_at')->where('user_id', $request->user_id)->latest()->get();

            if (count($data) > 0) {

                // Find Contest
                for ($i = 0; $i < count($data); $i++) {
                    if ($data[$i]->type == 1) {
                        $ContestName = Contest::where('id', $data[$i]->contest_id)->first();
                        $data[$i]->contest_name = $ContestName->name;
                    } elseif ($data[$i]->type == 2) {
                        $data[$i]->contest_name = "Quiz";
                    } elseif ($data[$i]->type == 3) {
                        $data[$i]->contest_name = "Audio Quiz";
                    } elseif ($data[$i]->type == 4) {
                        $data[$i]->contest_name = "Video Quiz";
                    } elseif ($data[$i]->type == 5) {
                        $data[$i]->contest_name = "True/False Quiz";
                    } elseif ($data[$i]->type == 6) {
                        $data[$i]->contest_name = "Daily Quiz";
                    }
                }

                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_reward_points(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $data = Reward_Transaction::where('user_id', $request->user_id)->orderBy('id', 'desc')->get();

            if (count($data) > 0) {

                foreach ($data as $row) {
                    $row->type_name = 'Daily';
                    if ($row->type == 1) {
                        $row->type_name = 'Spin to win';
                    }
                }

                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function get_transaction(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                return $this->common->API_Response(400,  __('api_msg.please_enter_required_fields'));
            }

            $data = Wallet_Transaction::where('user_id', $request->user_id)->latest()->get();

            if (count($data) > 0) {

                // Find Contest
                for ($i = 0; $i < count($data); $i++) {

                    $data[$i]->contest_name = "";
                    if ($data[$i]->contest_id) {
                        $ContestName = Contest::where('id', $data[$i]->contest_id)->first();
                        $data[$i]->contest_name = $ContestName->name;
                    }
                }
                return $this->common->API_Response(200,  __('api_msg.get_record_successfully'), $data);
            } else {
                return $this->common->API_Response(400,  __('api_msg.record_not_found'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
