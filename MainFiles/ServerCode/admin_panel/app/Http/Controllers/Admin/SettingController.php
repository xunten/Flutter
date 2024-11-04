<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Admin;
use App\Models\General_Setting;
use App\Models\Smtp;
use App\Models\Quiz_Configuration;
use App\Models\Common;
use App\Models\Social_Link;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Validator;
use Illuminate\Support\Facades\Auth;
use Exception;

class SettingController extends Controller
{
    private $folder = "app";
    public $common;
    public function __construct()
    {
        $this->common = new Common;
    }

    public function index()
    {
        try {

            $setting = General_Setting::get();
            $social_link = Social_Link::get();

            foreach ($setting as $row) {
                $data[$row->key] = $row->value;
            }
            $data['app_logo'] = $this->common->Get_Image($this->folder, $data['app_logo']);

            if ($data) {
                return view('admin.setting.index', ['result' => $data, 'social_link' => $social_link]);
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function app(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["app_name"] = isset($data['app_name']) ? $data['app_name'] : '';
                $data["host_email"] = isset($data['host_email']) ? $data['host_email'] : '';
                $data["app_version"] = isset($data['app_version']) ? $data['app_version'] : '';
                $data["author"] = isset($data['author']) ? $data['author'] : '';
                $data["email"] = isset($data['email']) ? $data['email'] : '';
                $data["contact"] = isset($data['contact']) ? $data['contact'] : '';
                $data["app_desripation"] = isset($data['app_desripation']) ? $data['app_desripation'] : '';
                $data["website"] = isset($data['website']) ? $data['website'] : '';

                if (isset($data['app_logo'])) {
                    $files = $data['app_logo'];
                    $data['app_logo'] = $this->common->saveImage($files, $this->folder);

                    $this->common->deleteImageToFolder($this->folder, basename($data['old_app_logo']));
                }

                foreach ($data as $key => $value) {

                    $setting = General_Setting::where('key', $key)->first();
                    if (isset($setting->id)) {
                        $setting->value = $value;
                        $setting->save();
                    }
                }
                return response()->json(array('status' => 200, 'success' => __('Label.save_setting')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function currency(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["currency"] = isset($data['currency']) ? $data['currency'] : '';
                $data["currency_code"] = isset($data['currency_code']) ? $data['currency_code'] : '';

                foreach ($data as $key => $value) {
                    $setting = General_Setting::where('key', $key)->first();
                    if (isset($setting->id)) {
                        $setting->value = $value;
                        $setting->save();
                    }
                }
                return response()->json(array('status' => 200, 'success' => __('Label.save_setting')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function changepassword(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $validator = Validator::make($request->all(), [
                    'password' => 'required|min:4',
                    'confirm_password' => 'required|min:4|same:password',
                ]);
                if ($validator->fails()) {
                    $errs = $validator->errors()->all();
                    return response()->json(array('status' => 400, 'errors' => $errs));
                }

                $data = Admin::where('id', $request->admin_id)->first();

                if (isset($data->id)) {
                    $data->password = Hash::make($request->password);
                    if ($data->save()) {
                        return response()->json(array('status' => 200, 'success' => __('Label.success_change_pass')));
                    } else {
                        return response()->json(array('status' => 400, 'errors' => __('Label.error_change_pass')));
                    }
                } else {
                    return response()->json(array('status' => 400, 'errors' => "errors"));
                }
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function admobAndroid(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["banner_adid"] = isset($data['banner_adid']) ? $data['banner_adid'] : '';
                $data["interstital_adid"] = isset($data['interstital_adid']) ? $data['interstital_adid'] : '';
                $data["reward_adid"] = isset($data['reward_adid']) ? $data['reward_adid'] : '';
                $data["interstital_adclick"] = isset($data['interstital_adclick']) ? $data['interstital_adclick'] : '';
                $data["reward_adclick"] = isset($data['reward_adclick']) ? $data['reward_adclick'] : '';

                foreach ($data as $key => $value) {
                    $setting = General_Setting::where('key', $key)->first();
                    if (isset($setting->id)) {
                        $setting->value = $value;
                        $setting->save();
                    }
                }
                return response()->json(array('status' => 200, 'success' => 'Setting Save'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function admobIos(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["ios_banner_adid"] = isset($data['ios_banner_adid']) ? $data['ios_banner_adid'] : '';
                $data["ios_interstital_adid"] = isset($data['ios_interstital_adid']) ? $data['ios_interstital_adid'] : '';
                $data["ios_reward_adid"] = isset($data['ios_reward_adid']) ? $data['ios_reward_adid'] : '';
                $data["ios_interstital_adclick"] = isset($data['ios_interstital_adclick']) ? $data['ios_interstital_adclick'] : '';
                $data["ios_reward_adclick"] = isset($data['ios_reward_adclick']) ? $data['ios_reward_adclick'] : '';

                foreach ($data as $key => $value) {
                    $setting = General_Setting::where('key', $key)->first();
                    if (isset($setting->id)) {
                        $setting->value = $value;
                        $setting->save();
                    }
                }
                return response()->json(array('status' => 200, 'success' => 'Setting Save'));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function facebookadAndroid(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["fb_native_id"] = isset($data['fb_native_id']) ? $data['fb_native_id'] : '';
                $data["fb_banner_id"] = isset($data['fb_banner_id']) ? $data['fb_banner_id'] : '';
                $data["fb_interstiatial_id"] = isset($data['fb_interstiatial_id']) ? $data['fb_interstiatial_id'] : '';
                $data["fb_rewardvideo_id"] = isset($data['fb_rewardvideo_id']) ? $data['fb_rewardvideo_id'] : '';
                $data["fb_native_full_id"] = isset($data['fb_native_full_id']) ? $data['fb_native_full_id'] : '';

                foreach ($data as $key => $value) {
                    $setting = General_Setting::where('key', $key)->first();
                    if (isset($setting->id)) {
                        $setting->value = $value;
                        $setting->save();
                    }
                }
                return response()->json(array('status' => 200, 'success' => __('Label.save_setting')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function facebookadIos(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["fb_ios_native_id"] = isset($data['fb_ios_native_id']) ? $data['fb_ios_native_id'] : '';
                $data["fb_ios_banner_id"] = isset($data['fb_ios_banner_id']) ? $data['fb_ios_banner_id'] : '';
                $data["fb_ios_interstiatial_id"] = isset($data['fb_ios_interstiatial_id']) ? $data['fb_ios_interstiatial_id'] : '';
                $data["fb_ios_rewardvideo_id"] = isset($data['fb_ios_rewardvideo_id']) ? $data['fb_ios_rewardvideo_id'] : '';
                $data["fb_ios_native_full_id"] = isset($data['fb_ios_native_full_id']) ? $data['fb_ios_native_full_id'] : '';

                foreach ($data as $key => $value) {
                    $setting = General_Setting::where('key', $key)->first();
                    if (isset($setting->id)) {
                        $setting->value = $value;
                        $setting->save();
                    }
                }
                return response()->json(array('status' => 200, 'success' => __('Label.save_setting')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // SMTP
    public function smtpIndex()
    {
        try {
            $smtp = Smtp::latest()->first();
            return view('admin.setting.smtp', ['smtp' => $smtp]);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function smtpSave(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $validator = Validator::make($request->all(), [
                    'status' => 'required',
                    'host' => 'required',
                    'port' => 'required',
                    'protocol' => 'required',
                    'user' => 'required',
                    'pass' => 'required',
                    'from_name' => 'required',
                    'from_email' => 'required',
                ]);
                if ($validator->fails()) {
                    $errs = $validator->errors()->all();
                    return response()->json(array('status' => 400, 'errors' => $errs));
                }

                if (isset($request->id) && $request->id != null && $request->id != "") {

                    $smtp = Smtp::where('id', $request->id)->first();
                    if (isset($smtp->id)) {
                        $smtp->protocol = $request->protocol;
                        $smtp->host = $request->host;
                        $smtp->port = $request->port;
                        $smtp->user = $request->user;
                        $smtp->pass = $request->pass;
                        $smtp->from_name = $request->from_name;
                        $smtp->from_email = $request->from_email;
                        $smtp->status = $request->status;
                        if ($smtp->save()) {
                            return response()->json(array('status' => 200, 'success' => __('Label.save_setting')));
                        } else {
                            return response()->json(array('status' => 400, 'errors' => "SMTP Not Saved."));
                        }
                    }
                } else {

                    $insert = new Smtp();
                    $insert->protocol = $request->protocol;
                    $insert->host = $request->host;
                    $insert->port = $request->port;
                    $insert->user = $request->user;
                    $insert->pass = $request->pass;
                    $insert->from_name = $request->from_name;
                    $insert->from_email = $request->from_email;
                    $insert->status = $request->status;
                    if ($insert->save()) {
                        return response()->json(array('status' => 200, 'success' => __('Label.save_setting')));
                    } else {
                        return response()->json(array('status' => 400, 'errors' => "SMTP Not Saved."));
                    }
                }
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // Quiz Configuration
    public function quizConfiguration()
    {
        try {
            $data = [];

            $quiz_configuration = Quiz_Configuration::get();
            foreach ($quiz_configuration as $row) {
                $data[$row->key] = $row->value;
            }

            return view('admin.setting.quiz_configuration', ['quiz_configuration' => $data,]);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function quizConfigurationSave(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {

                $validator = Validator::make($request->all(), [
                    'audio_question' => 'required|numeric|min:0',
                    'min_audio_percentage' => 'required|numeric|min:0',
                    'audio_win_point' => 'required|numeric|min:0',
                    'video_question' => 'required|numeric|min:0',
                    'min_video_percentage' => 'required|numeric|min:0',
                    'video_win_point' => 'required|numeric|min:0',
                    'true_false_question' => 'required|numeric|min:0',
                    'min_true_false_percentage' => 'required|numeric|min:0',
                    'true_false_win_point' => 'required|numeric|min:0',
                    'daily_quiz_question' => 'required|numeric|min:0',
                    'min_daily_quiz_percentage' => 'required|numeric|min:0',
                    'daily_quiz_win_point' => 'required|numeric|min:0',
                ]);
                if ($validator->fails()) {
                    $errs = $validator->errors()->all();
                    return response()->json(array('status' => 400, 'errors' => $errs));
                }

                $data = $request->all();
                $data["audio_question"] = isset($data['audio_question']) ? $data['audio_question'] : 0;
                $data["min_audio_percentage"] = isset($data['min_audio_percentage']) ? $data['min_audio_percentage'] : 0;
                $data["audio_win_point"] = isset($data['audio_win_point']) ? $data['audio_win_point'] : 0;

                $data["video_question"] = isset($data['video_question']) ? $data['video_question'] : 0;
                $data["min_video_percentage"] = isset($data['min_video_percentage']) ? $data['min_video_percentage'] : 0;
                $data["video_win_point"] = isset($data['video_win_point']) ? $data['video_win_point'] : 0;

                $data["true_false_question"] = isset($data['true_false_question']) ? $data['true_false_question'] : 0;
                $data["min_true_false_percentage"] = isset($data['min_true_false_percentage']) ? $data['min_true_false_percentage'] : 0;
                $data["true_false_win_point"] = isset($data['true_false_win_point']) ? $data['true_false_win_point'] : 0;

                $data["daily_quiz_question"] = isset($data['daily_quiz_question']) ? $data['daily_quiz_question'] : 0;
                $data["min_daily_quiz_percentage"] = isset($data['min_daily_quiz_percentage']) ? $data['min_daily_quiz_percentage'] : 0;
                $data["daily_quiz_win_point"] = isset($data['daily_quiz_win_point']) ? $data['daily_quiz_win_point'] : 0;

                foreach ($data as $key => $value) {

                    $setting = Quiz_Configuration::where('key', $key)->first();
                    if (isset($setting->id)) {
                        $setting->value = $value;
                        $setting->save();
                    }
                }
                return response()->json(array('status' => 200, 'success' => __('Label.save_setting')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    // Social Link
    public function SaveSocialLink(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {

                $arr_name = $request['name'];
                $arr_url = $request['url'];
                $arr_img = $request->file('image');
                $arr_old_image = $request['old_image'];

                // Save New All Link
                $not_delete_img = array();
                $not_delete_ids = array();

                for ($i = 0; $i < count($arr_name); $i++) {

                    if (!empty($arr_name[$i]) && !empty($arr_url[$i])) {

                        if (!empty($arr_img[$i])) {

                            $insert = new Social_Link();
                            $insert->name = $arr_name[$i];
                            $insert->url = $arr_url[$i];
                            $insert->image = $this->common->saveImage($arr_img[$i], $this->folder);
                            $insert->save();

                            $this->common->deleteImageToFolder($this->folder, $arr_old_image[$i]);
                        } else {
                            if (!empty($arr_old_image[$i])) {

                                $insert = new Social_Link();
                                $insert->name = $arr_name[$i];
                                $insert->url = $arr_url[$i];
                                $insert->image = $arr_old_image[$i];
                                $insert->save();
                                $not_delete_img[] = $arr_old_image[$i];
                            }
                        }
                        $not_delete_ids[] = $insert->id;
                    }
                }

                // Delete Old All Link 
                $all_old_link = Social_Link::whereNotIn('id', $not_delete_ids)->get();
                for ($i = 0; $i < count($all_old_link); $i++) {

                    if (!in_array($all_old_link[$i]['image'], $not_delete_img)) {

                        $this->common->deleteImageToFolder($this->folder, $all_old_link[$i]['image']);
                    }

                    $all_old_link[$i]->delete();
                }

                return response()->json(array('status' => 200, 'success' => "Social Setting Save Success Fully."));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
