<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\General_Setting;
use App\Models\Common;
use App\Models\Notification;
use Illuminate\Http\Request;
use Validator;
use Exception;

class NotificationController extends Controller
{
    private $folder = "notification";
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
                    $data = Notification::where('title', 'LIKE', "%{$input_search}%")->latest()->get();
                } else {
                    $data = Notification::latest()->get();
                }

                // Image Name to URL
                $this->common->imageNameToUrl($data, 'image', $this->folder);

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = ' <form onsubmit="return confirm(\'Are you sure !!! You want to Delete this Notification ?\');" method="POST"  action="' . route('notification.destroy', [$row->id]) . '">
                            <input type="hidden" name="_token" value="' . csrf_token() . '">
                            <input type="hidden" name="_method" value="DELETE">
                            <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';
                        $btn = $delete;
                        return $btn;
                    })
                    ->rawColumns(['action'])
                    ->make(true);
            }
            return view('admin.notification.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function create()
    {
        try {
            return view('admin.notification.add');
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'title' => 'required',
                'description' => 'required',
                'image' => 'image|mimes:jpeg,png,jpg|max:2048',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $requestData = $request->all();

            $insert = new Notification();
            $insert->title = $request->title;
            $insert->description = $request->description;

            $notificationImageURL = '';
            if (isset($requestData['image'])) {
                $files = $requestData['image'];
                $insert->image = $this->common->saveImage($files, $this->folder);

                // Image Name to URL
                $notificationImageURL = $this->common->Get_Image($this->folder, $insert->image);
            } else {
                $insert->image = "";
            }

            if ($insert->save()) {

                // Notification Send App
                $noty = General_Setting::where('key', 'onesignal_apid')->orWhere('key', 'onesignal_rest_key')->get();
                $notification = [];
                foreach ($noty as $row) {
                    $notification[$row->key] = $row->value;
                }

                $ONESIGNAL_APP_ID = $notification['onesignal_apid'];
                $ONESIGNAL_REST_KEY = $notification['onesignal_rest_key'];

                $content = array(
                    "en" => $request->description,
                );

                $fields = array(
                    'app_id' => $ONESIGNAL_APP_ID,
                    'included_segments' => array('All'),
                    'data' => array("foo" => "bar"),
                    'headings' => array("en" => $request->title),
                    'contents' => $content,
                    'big_picture' => $notificationImageURL,
                );

                $fields = json_encode($fields);

                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, "https://onesignal.com/api/v1/notifications");
                curl_setopt($ch, CURLOPT_HTTPHEADER, array(
                    'Content-Type: application/json; charset=utf-8',
                    'Authorization: Basic ' . $ONESIGNAL_REST_KEY,
                ));
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_HEADER, false);
                curl_setopt($ch, CURLOPT_POST, true);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

                $response = curl_exec($ch);
                // dd($response);
                curl_close($ch);

                return response()->json(array('status' => 200, 'success' => __('Label.success_add_notification')));
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.error_send_notification')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function destroy($id)
    {
        try {
            $data = Notification::where('id', $id)->first();
            if (isset($data)) {
                $this->common->deleteImageToFolder($this->folder, $data['image']);
                $data->delete();
            }
            return redirect()->route('notification.index')->with('success', __('Label.Notification Delete Successfully.'));
        } catch (Exception $e) {
            return redirect('category')->with($e);
        }
    }

    // Settings
    public function setting()
    {
        try {

            $setting = General_Setting::get();
            foreach ($setting as $row) {
                $data[$row->key] = $row->value;
            }
            return view('admin.notification.setting', ['result' => $data]);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function settingsave(Request $request)
    {
        try {
            $data = $request->all();
            $data["onesignal_apid"] = isset($data['onesignal_apid']) ? $data['onesignal_apid'] : '';
            $data["onesignal_rest_key"] = isset($data['onesignal_rest_key']) ? $data['onesignal_rest_key'] : '';

            foreach ($data as $key => $value) {

                $setting = General_Setting::where('key', $key)->first();
                if (isset($setting->id)) {
                    $setting->value = $value;
                    $setting->save();
                }
            }
            return response()->json(array('status' => 200, 'success' => __('Label.save_setting')));
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
