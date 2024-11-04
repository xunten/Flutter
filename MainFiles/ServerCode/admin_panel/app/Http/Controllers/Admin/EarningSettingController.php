<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Earnpoint_Setting;
use App\Models\Earn_point;
use App\Models\General_Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Exception;

class EarningSettingController extends Controller
{
    public function index()
    {
        try {
            $setting = General_Setting::get();
            $earnpoint = Earnpoint_Setting::get();
            $earn_point = Earn_point::get();

            foreach ($setting as $row) {
                $data[$row->key] = $row->value;
            }
            foreach ($earnpoint as $row) {
                $earnpoint[$row->key] = $row->value;
            }
            foreach ($earn_point as $row) {
                $earn_point[$row->key] = $row->value;
            }
            return view('admin.earning_setting.index', ['result' => $data, 'earnpoint' => $earnpoint, 'earn_point' => $earn_point]);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function earningSetting(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["earning_point"] = isset($data['earning_point']) ? $data['earning_point'] : '';
                $data["earning_amount"] = isset($data['earning_amount']) ? $data['earning_amount'] : '';
                $data["currency"] = isset($data['currency']) ? $data['currency'] : '';
                $data["min_earning_point"] = isset($data['min_earning_point']) ? $data['min_earning_point'] : '';
                $data["daily_refer_limit"] = isset($data['daily_refer_limit']) ? $data['daily_refer_limit'] : '';
                $data["wallet_withdraw_visibility"] = isset($data['wallet_withdraw_visibility']) ? $data['wallet_withdraw_visibility'] : '';

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
    public function setEarningPoint(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["Level"] = isset($data['Level']) ? $data['Level'] : '';
                $data["Registration"] = isset($data['Registration']) ? $data['Registration'] : '';
                $data["ReferUser"] = isset($data['ReferUser']) ? $data['ReferUser'] : '';

                foreach ($data as $key => $value) {
                    $setting = Earnpoint_Setting::where('key', $key)->first();
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
    public function spinWheelPoint(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["1"] = isset($data['1']) ? $data['1'] : '';
                $data["2"] = isset($data['2']) ? $data['2'] : '';
                $data["3"] = isset($data['3']) ? $data['3'] : '';
                $data["4"] = isset($data['4']) ? $data['4'] : '';
                $data["5"] = isset($data['5']) ? $data['5'] : '';
                $data["6"] = isset($data['6']) ? $data['6'] : '';

                foreach ($data as $key => $value) {
                    $setting = Earn_point::where('key', $key)->first();
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
    public function dailyLoginPoint(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["Day-1"] = isset($data['Day-1']) ? $data['Day-1'] : '';
                $data["Day-2"] = isset($data['Day-2']) ? $data['Day-2'] : '';
                $data["Day-3"] = isset($data['Day-3']) ? $data['Day-3'] : '';
                $data["Day-4"] = isset($data['Day-4']) ? $data['Day-4'] : '';
                $data["Day-5"] = isset($data['Day-5']) ? $data['Day-5'] : '';
                $data["Day-6"] = isset($data['Day-6']) ? $data['Day-6'] : '';
                $data["Day-7"] = isset($data['Day-7']) ? $data['Day-7'] : '';

                foreach ($data as $key => $value) {
                    $setting = Earn_point::where('key', $key)->first();
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
    public function getFreeCongPoint(Request $request)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.You have no right to add, edit, and delete')));
            } else {
                $data = $request->all();
                $data["free-coin"] = isset($data['free-coin']) ? $data['free-coin'] : '';

                foreach ($data as $key => $value) {
                    $setting = Earn_point::where('key', $key)->first();
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
}
