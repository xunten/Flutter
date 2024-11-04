<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pratice_Leaderborad;
use App\Models\Transaction;
use App\Models\Common;
use App\Models\Users;
use App\Models\Withdrawal;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Validator;
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

    public function index(Request $request)
    {
        try {

            $params['data'] = [];
            if ($request->ajax()) {

                $input_search = $request['input_search'];
                $input_type = $request['input_type'];
                $input_login_type = $request['input_login_type'];

                if ($input_search != null && isset($input_search)) {

                    if ($input_login_type == "all") {

                        if ($input_type == "today") {

                            $data = Users::where(function ($query) use ($input_search) {
                                $query->where('fullname', 'LIKE', "%{$input_search}%")->orWhere('email', 'LIKE', "%{$input_search}%")->orWhere('mobile_number', 'LIKE', "%{$input_search}%");
                            })
                                ->whereDay('created_at', date('d'))
                                ->whereMonth('created_at', date('m'))
                                ->whereYear('created_at', date('Y'))
                                ->latest()->get();
                        } else if ($input_type == "month") {

                            $data = Users::where(function ($query) use ($input_search) {
                                $query->where('fullname', 'LIKE', "%{$input_search}%")->orWhere('email', 'LIKE', "%{$input_search}%")->orWhere('mobile_number', 'LIKE', "%{$input_search}%");
                            })
                                ->whereMonth('created_at', date('m'))
                                ->whereYear('created_at', date('Y'))
                                ->latest()->get();
                        } else if ($input_type == "year") {

                            $data = Users::where(function ($query) use ($input_search) {
                                $query->where('fullname', 'LIKE', "%{$input_search}%")->orWhere('email', 'LIKE', "%{$input_search}%")->orWhere('mobile_number', 'LIKE', "%{$input_search}%");
                            })
                                ->whereYear('created_at', date('Y'))
                                ->latest()->get();
                        } else {

                            $data = Users::where(function ($query) use ($input_search) {
                                $query->where('fullname', 'LIKE', "%{$input_search}%")->orWhere('email', 'LIKE', "%{$input_search}%")->orWhere('mobile_number', 'LIKE', "%{$input_search}%");
                            })
                                ->latest()->get();
                        }
                    } else {

                        if ($input_type == "today") {

                            $data = Users::where(function ($query) use ($input_search) {
                                $query->where('fullname', 'LIKE', "%{$input_search}%")->orWhere('email', 'LIKE', "%{$input_search}%")->orWhere('mobile_number', 'LIKE', "%{$input_search}%");
                            })
                                ->where('type', $input_login_type)
                                ->whereDay('created_at', date('d'))
                                ->whereMonth('created_at', date('m'))
                                ->whereYear('created_at', date('Y'))
                                ->latest()->get();
                        } else if ($input_type == "month") {

                            $data = Users::where(function ($query) use ($input_search) {
                                $query->where('fullname', 'LIKE', "%{$input_search}%")->orWhere('email', 'LIKE', "%{$input_search}%")->orWhere('mobile_number', 'LIKE', "%{$input_search}%");
                            })
                                ->where('type', $input_login_type)
                                ->whereMonth('created_at', date('m'))
                                ->whereYear('created_at', date('Y'))
                                ->latest()->get();
                        } else if ($input_type == "year") {

                            $data = Users::where(function ($query) use ($input_search) {
                                $query->where('fullname', 'LIKE', "%{$input_search}%")->orWhere('email', 'LIKE', "%{$input_search}%")->orWhere('mobile_number', 'LIKE', "%{$input_search}%");
                            })
                                ->where('type', $input_login_type)
                                ->whereYear('created_at', date('Y'))
                                ->latest()->get();
                        } else {

                            $data = Users::where(function ($query) use ($input_search) {
                                $query->where('fullname', 'LIKE', "%{$input_search}%")->orWhere('email', 'LIKE', "%{$input_search}%")->orWhere('mobile_number', 'LIKE', "%{$input_search}%");
                            })
                                ->where('type', $input_login_type)
                                ->latest()->get();
                        }
                    }
                } else {

                    if ($input_login_type == "all") {

                        if ($input_type == "today") {

                            $data = Users::whereDay('created_at', date('d'))->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'))->latest()->get();
                        } else if ($input_type == "month") {

                            $data = Users::whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'))->latest()->get();
                        } else if ($input_type == "year") {

                            $data = Users::whereYear('created_at', date('Y'))->latest()->get();
                        } else {

                            $data = Users::latest()->get();
                        }
                    } else {

                        if ($input_type == "today") {

                            $data = Users::where('type', $input_login_type)->whereDay('created_at', date('d'))->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'))->latest()->get();
                        } else if ($input_type == "month") {

                            $data = Users::where('type', $input_login_type)->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'))->latest()->get();
                        } else if ($input_type == "year") {

                            $data = Users::where('type', $input_login_type)->whereYear('created_at', date('Y'))->latest()->get();
                        } else {

                            $data = Users::where('type', $input_login_type)->latest()->get();
                        }
                    }
                }

                // Image Name to URL
                $this->common->imageNameToUrl($data, 'profile_img', $this->folder);

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = '<form onsubmit="return confirm(\'Are you sure !!! You want to Delete this User ?\');" method="POST"  action="' . route('user.destroy', [$row->id]) . '">
                                <input type="hidden" name="_token" value="' . csrf_token() . '">
                                <input type="hidden" name="_method" value="DELETE">
                                <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';

                        $btn = '<div class="d-flex justify-content-around" title="Edit">';
                        $btn .= '<a href="' . route('user.edit', [$row->id]) . '" class="edit-delete-btn">';
                        $btn .= '<i class="fa-solid fa-pen-to-square fa-xl"></i>';
                        $btn .= '</a>';
                        $btn .= $delete;
                        $btn .= '</a></div>';
                        return $btn;
                    })
                    ->addColumn('date', function ($row) {
                        $date = date("Y-m-d", strtotime($row->created_at));
                        return $date;
                    })
                    ->rawColumns(['action'])
                    ->make(true);
            }
            return view('admin.user.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function create()
    {
        try {
            $params['data'] = [];
            return view('admin.user.add', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'fullname' => 'required|min:2',
                'mobile_number' => 'required|numeric|unique:tbl_user,mobile_number',
                'email' => 'required|unique:tbl_user|email',
                'password' => 'required|min:4',
                'profile_img' => 'required|image|mimes:jpeg,png,jpg|max:2048',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $user = new Users();

            $email_array = explode('@', $request->email);
            $user->username = $this->common->user_name($email_array[0]);
            $user->fullname = $request->fullname;
            $user->mobile_number = $request->mobile_number;
            $user->email = $request->email;
            $user->password = Hash::make($request->password);
            $user->instagram_url = $request['instagram_url'] ?? "";
            $user->facebook_url = $request['facebook_url'] ?? "";
            $user->twitter_url = $request['twitter_url'] ?? "";
            $user->biodata = $request['biodata'] ?? $this->common->user_tag_line();
            $user->address = "";
            $user->reference_code = Str::random(8);
            $user->parent_reference_code = "";
            $user->pratice_quiz_score = 0;
            $user->total_score = 0;
            $user->total_points = 0;
            $user->device_type = 0;
            $user->device_token = "";
            $user->status = 1;
            $user->type = 1;

            if (isset($request->profile_img)) {

                $files = $request->profile_img;
                $user->profile_img = $this->common->saveImage($files, $this->folder);
            }

            if ($user->save()) {
                return response()->json(array('status' => 200, 'success' => __('Label.success_add_user')));
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.error_add_user')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function edit($id)
    {
        try {
            $user = Users::where('id', $id)->first();
            if (isset($user->id)) {

                // Image Name to URL
                $this->common->imageNameToUrl(array($user), 'profile_img', $this->folder);

                return view('admin.user.edit', ['result' => $user]);
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
                'fullname' => 'required|min:2',
                'email' => 'required|email|unique:tbl_user,email,' . $request->id,
                'mobile_number' => 'required|numeric|unique:tbl_user,mobile_number,' . $request->id,
                'image' => 'image|mimes:jpeg,png,jpg|max:2048',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $user = Users::where('id', $request->id)->first();
            if (isset($user->id)) {

                $user->fullname = $request->fullname;
                $user->mobile_number = $request->mobile_number;
                $user->email = $request->email;
                $user->instagram_url = $request->instagram_url ?? "";
                $user->facebook_url = $request->facebook_url ?? "";
                $user->twitter_url = $request->twitter_url ?? "";
                $user->biodata = $request->biodata ?? $this->common->user_tag_line();
                $user->is_updated = 1;

                if (isset($request->profile_img)) {
                    $files = $request->profile_img;
                    $user->profile_img = $this->common->saveImage($files, $this->folder);

                    $this->common->deleteImageToFolder($this->folder, basename($request->old_profile_img));
                }

                if ($user->save()) {
                    return response()->json(array('status' => 200, 'success' => __('Label.success_edit_user')));
                } else {
                    return response()->json(array('status' => 400, 'errors' => __('Label.error_edit_user')));
                }
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.error_edit_user')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function destroy($id)
    {
        try {
            $user = Users::where('id', $id)->first();
            $pratice_leaderborad = Pratice_Leaderborad::where('user_id', $id)->first();
            $transaction = Transaction::where('user_id', $id)->first();
            $withdrawal = Withdrawal::where('user_id', $id)->first();

            if ($pratice_leaderborad !== null) {
                return back()->with('error', __('Label.This User is used on some other table so you can not remove it.'));
            } elseif ($transaction !== null) {
                return back()->with('error', __('Label.This User is used on some other table so you can not remove it.'));
            } elseif ($withdrawal !== null) {
                return back()->with('error', __('Label.This User is used on some other table so you can not remove it.'));
            }

            if (isset($user)) {
                $this->common->deleteImageToFolder($this->folder, $user['profile_img']);
                $user->delete();
            }
            return redirect()->route('user.index')->with('success', __('Label.User Delete Successfully.'));
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
