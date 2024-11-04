<?php

namespace App\Models;

use Config;
use Illuminate\Database\Eloquent\Model;
use Storage;
use App\Models\Quiz_Configuration;
use Exception;
use Illuminate\Support\Facades\Mail;

class Common extends Model
{

    public function Get_Image($folder = "", $name = "")
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
    public function imageNameToUrl($array, $column, $folder)
    {
        try {
            foreach ($array as $key => $value) {
                $appName = Config::get('app.image_url');
                if (isset($value[$column]) && $value[$column] != "") {
                    if ($folder == "user") {
                        if (Storage::disk('public')->exists($folder . '/' . $value[$column])) {
                            $value[$column] = $appName . $folder . '/' . $value[$column];
                        } else {
                            $value[$column] = asset('assets/imgs/default.png');
                        }
                    } else {
                        if (Storage::disk('public')->exists($folder . '/' . $value[$column])) {
                            $value[$column] = $appName . $folder . '/' . $value[$column];
                        } else {
                            $value[$column] = asset('assets/imgs/no_img.png');
                        }
                    }
                } else {
                    if ($folder == "user") {
                        $value[$column] = asset('assets/imgs/default.png');
                    } else {
                        $value[$column] = asset('assets/imgs/no_img.png');
                    }
                }
            }
            return $array;
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function saveImage($org_name, $folder)
    {
        try {
            $img_ext = $org_name->getClientOriginalExtension();
            $filename = rand(1, 100) . time() . '.' . $img_ext;
            $path = $org_name->move(base_path('storage/app/public/' . $folder), $filename);
            return $filename;
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function deleteImageToFolder($folder, $name)
    {
        try {

            Storage::disk('public')->delete($folder . '/' . $name);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function API_Response($status_code, $message, $array = [], $pagination = '')
    {
        try {
            $data['status'] = $status_code;
            $data['message'] = $message;
            if ($status_code == 200) {
                $data['result'] = $array;
            }

            if ($pagination) {
                $data['total_rows'] = $pagination['total_rows'];
                $data['total_page'] = $pagination['total_page'];
                $data['current_page'] = $pagination['current_page'];
                $data['more_page'] = $pagination['more_page'];
            }

            return $data;
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    function Level_Is_unlock($user_id, $category_id, $level_id)
    {
        $is_unlock = QuestioLeaderboard::where('user_id', $user_id)->where('category_id', $category_id)->where('level_id', $level_id)
            ->join('tbl_level', 'tbl_level.id', 'level_id')
            ->orderby('correct_answers', 'asc')
            ->first();
        return $is_unlock;
    }
    function add_earn_transaction($user_id, $contest_id, $type, $point) // $type (1= Contest, 2= Normal Quiz, 3= Audio Quiz 4= Video Quiz, 5= True/False Quiz, 6= Daily Quiz)
    {
        $insert = new Earn_transaction();
        $insert->user_id = $user_id;
        $insert->contest_id = $contest_id;
        $insert->type = $type;
        $insert->point = $point;
        $insert->save();
        return true;
    }
    public function get_quiz_configuraction()
    {
        try {

            $setting = Quiz_Configuration::get();
            $data = [];
            foreach ($setting as $value) {
                $data[$value->key] = $value->value;
            }
            return $data;
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function user_name($string)
    {
        $rand_number = rand(0, 1000);
        $user_name = '@' . $string . $rand_number;

        $check = Users::where('username', $user_name)->first();
        if (isset($check) && $check != null) {
            $this->user_name($string);
        }
        return $user_name;
    }
    public function user_tag_line()
    {
        $bio_data = "Hey, I am using the " . App_Name() . " App.";
        return $bio_data;
    }
    function Send_Mail($type, $email) // Type = 1- Register Mail, 2 Transaction Mail
    {
        try {

            $smtp = smtpData();
            if (isset($smtp) && $smtp != false && $smtp['status'] == 1) {

                if ($type == 1) {
                    $title = App_Name() . " - Register";
                    $body = "Welcome to " . App_Name() . " App & Enjoy this app.";
                } else if ($type == 2) {
                    $title = App_Name() . " - Transaction";
                    $body = "Welcome to " . App_Name() . " App & Enjoy this app. You have Successfully Transaction.";
                } else {
                    return true;
                }
                $details = [
                    'title' => $title,
                    'body' => $body
                ];

                // Send Mail
                try {
                    Mail::to($email)->send(new \App\Mail\mail($details));
                    return true;
                } catch (\Swift_TransportException $e) {
                    return true;
                }
            } else {
                return true;
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
