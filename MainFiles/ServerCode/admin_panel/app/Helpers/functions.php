<?php

use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Config;
use App\Models\General_Setting;
use App\Models\Smtp;
use Illuminate\Support\Facades\Auth;

function lang()
{
    $lang = \App\Models\Language::get();
    return $lang;
}
function string_cut($string, $len)
{
    if (strlen($string) > $len) {
        $string = mb_substr(strip_tags($string), 0, $len, 'utf-8') . '...';
        // $string = substr(strip_tags($string),0,$len).'...';
    }
    return $string;
}
function settingData()
{
    $setting = General_Setting::get();
    $data = [];
    foreach ($setting as $value) {
        $data[$value->key] = $value->value;
    }
    return $data;
}
function tab_icon()
{
    $settingData = settingData();
    $name = $settingData['app_logo'];
    $folder = "app";

    if ($name != "" && $folder != "") {

        $appName = Config::get('app.image_url');

        if (Storage::disk('public')->exists($folder . '/' . $name)) {
            $data = $appName . $folder . '/' . $name;
        } else {
            $data = asset('assets/imgs/no_img.png');
        }
    } else {
        $data = asset('/assets/imgs/no_img.png');
    }
    return ($data);
}
function adminData()
{
    return $emails = \App\Models\Admin::select('username', 'email')->first();
}
function no_format($num)
{
    if ($num > 1000) {
        $x = round($num);
        $x_number_format = number_format($x);
        $x_array = explode(',', $x_number_format);
        $x_parts = array('K', 'M', 'B', 'T');
        $x_count_parts = count($x_array) - 1;
        $x_display = $x;
        $x_display = $x_array[0] . ((int) $x_array[1][0] !== 0 ? '.' . $x_array[1][0] : '');
        $x_display .= $x_parts[$x_count_parts - 1];

        return $x_display;
    }
    return $num;
}
function currency_code()
{
    $setting = \App\Models\General_Setting::get();
    $data = [];
    foreach ($setting as $value) {
        $data[$value->key] = $value->value;
    }
    return $data['currency_code'];
}
function smtpData()
{
    $setting = Smtp::latest()->first();
    if (isset($setting) && $setting != null) {
        return $setting;
    }
    return false;
}
function MenuData()
{
    $setting = \App\Models\Menu::get();
    $data = [];
    foreach ($setting as $value) {
        $data[$value->name] = $value->status;
    }
    return $data;
}
function App_Name()
{
    $setting = General_Setting::get();
    $data = [];
    foreach ($setting as $value) {
        $data[$value->key] = $value->value;
    }
    $app_name = $data['app_name'];

    if (isset($app_name) && $app_name != "") {
        return $app_name;
    } else {
        return env('APP_NAME');
    }
}
function Check_Admin_Access()
{
    if (Auth::guard('admin')->user()->type != 1) {
        return 0;
    } else {
        return 1;
    }
}
function Get_Image($folder = "", $name = "")
{
    $appName = Config::get('app.image_url');
    if ($name != "" && $folder != "") {
        if ($folder == "user") {
            if (Storage::disk('public')->exists($folder . '/' . $name)) {
                $data = $appName . $folder . '/' . $name;
            } else {
                $data = asset('assets/imgs/default.png');
            }
        } else {
            if (Storage::disk('public')->exists($folder . '/' . $name)) {
                $data = $appName . $folder . '/' . $name;
            } else {
                $data = asset('assets/imgs/no_img.png');
            }
        }
    } else {
        if ($folder == "user") {
            $data = asset('assets/imgs/default.png');
        } else {
            $data = asset('assets/imgs/no_img.png');
        }
    }
    return ($data);
}
