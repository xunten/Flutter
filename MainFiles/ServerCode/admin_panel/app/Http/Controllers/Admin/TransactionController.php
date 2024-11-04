<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Models\Users;
use App\Models\Common;
use App\Models\Subscription_Plan;
use Illuminate\Http\Request;
use Validator;
use Exception;

class TransactionController extends Controller
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

                $input_type = $request['input_type'];
                $input_search = $request['input_search'];

                if ($input_type == "today") {

                    if ($input_search != null && isset($input_search)) {
                        $data = Transaction::where('transaction_id', 'LIKE', "%{$input_search}%")
                            ->with('plan_subscription', 'users')->whereDay('created_at', date('d'))
                            ->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'))->latest()->get();
                    } else {
                        $data = Transaction::with('plan_subscription', 'users')->whereDay('created_at', date('d'))
                            ->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'))->latest()->get();
                    }
                } else if ($input_type == "month") {

                    if ($input_search != null && isset($input_search)) {
                        $data = Transaction::where('transaction_id', 'LIKE', "%{$input_search}%")->with('plan_subscription', 'users')
                            ->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'))->latest()->get();
                    } else {
                        $data = Transaction::with('plan_subscription', 'users')->whereMonth('created_at', date('m'))
                            ->whereYear('created_at', date('Y'))->latest()->get();
                    }
                } else if ($input_type == "year") {

                    if ($input_search != null && isset($input_search)) {
                        $data = Transaction::where('transaction_id', 'LIKE', "%{$input_search}%")->with('plan_subscription', 'users')
                            ->whereYear('created_at', date('Y'))->latest()->get();
                    } else {
                        $data = Transaction::with('plan_subscription', 'users')->whereYear('created_at', date('Y'))->latest()->get();
                    }
                } else {
                    if ($input_search != null && isset($input_search)) {
                        $data = Transaction::where('transaction_id', 'LIKE', "%{$input_search}%")->with('plan_subscription', 'users')->latest()->get();
                    } else {
                        $data = Transaction::with('plan_subscription', 'users')->latest()->get();
                    }
                }

                foreach ($data as $key => $value) {
                    $value['profile_img'] = $this->common->Get_Image($this->folder, $value['users']['profile_img']);
                }

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('date', function ($row) {
                        $date = date("Y-m-d", strtotime($row->created_at));
                        return $date;
                    })
                    ->make(true);
            }

            return view('admin.transaction.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function create(Request $request)
    {
        try {
            $params['data'] = [];
            $params['user'] = Users::where('id', $request->user_id)->first();
            $params['package'] = Subscription_Plan::get();

            return view('admin.transaction.add', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function searchUser(Request $request)
    {
        try {

            $name = $request->name;
            $user = Users::orWhere('fullname', 'like', '%' . $name . '%')->orWhere('mobile_number', 'like', '%' . $name . '%')->orWhere('email', 'like', '%' . $name . '%')->get();

            $url = url('admin/transaction/create?user_id');
            $text = '<table width="100%" class="table table-striped category-table text-center table-bordered"><tr style="background: #F9FAFF;"><th>Full Name</th><th>Mobile</th><th>Email</th><th>Action</th></tr>';
            if ($user->count() > 0) {
                foreach ($user as $row) {

                    $a = '<a class="btn-link" href="' . $url . '=' . $row->id . '">Select</a>';
                    $text .= '<tr><td>' . $row->fullname . '</td><td>' . $row->mobile_number . '</td><td>' . $row->email . '</td><td>' . $a . '</td></tr>';
                }
            } else {
                $text .= '<tr><td colspan="4">User Not Found</td></tr>';
            }
            $text .= '</table>';

            return response()->json(array('status' => 200, 'success' => 'Search User', 'result' => $text));
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'user_id' => 'required|numeric',
                'package_id' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $package = Subscription_Plan::where('id', $request->package_id)->first();

            $Transction = new Transaction();
            $Transction->user_id = $request->user_id;
            $Transction->plan_subscription_id = $request->package_id;
            $Transction->transaction_id = 'admin';
            $Transction->transaction_amount = $package->price;
            $Transction->point = $package->point;

            if ($Transction->save()) {
                if ($Transction->id) {

                    Users::where('id', $request->user_id)->increment('total_points', $package->point);
                    return response()->json(array('status' => 200, 'success' => __('Label.Transction_Add_Successfully')));
                } else {
                    return response()->json(array('status' => 400, 'errors' => __('Label.Transction_Not_Add')));
                }
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.Transction_Not_Add')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
