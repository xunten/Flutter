<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Withdrawal;
use App\Models\Common;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Exception;

class WithdrawalController extends Controller
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

                $data = Withdrawal::with('users')->orderBy('status', 'asc')->orderBy('id', 'desc')->latest()->get();

                foreach ($data as $key => $value) {
                    $value['profile_img'] = $this->common->Get_Image($this->folder, $value['users']['profile_img']);
                }

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('date', function ($row) {
                        return date("Y-m-d", strtotime($row->created_at));
                    })
                    ->addColumn('action', function ($row) {
                        if ($row->status == 1) {
                            return "<button type='button' id='$row->id' onclick='change_status($row->id, $row->status)' style='background:#4e45b8; font-weight:bold; border: none;  color: white; padding: 4px 10px; outline: none; border-radius: 5px;cursor: pointer;'>Completed</button>";
                        } else {
                            return "<button type='button' id='$row->id' onclick='change_status($row->id, $row->status)' style='background:#4e45b8; font-weight:bold; border: none;  color: white; padding: 4px 20px; outline: none; border-radius: 5px;cursor: pointer;'>Pending</button>";
                        }
                    })
                    ->make(true);
            }
            return view('admin.withdrawal.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function show($id)
    {
        try {
            if (Auth::guard('admin')->user()->type != 1) {
                return response()->json(array('status' => 400, 'errors' => __('Label.you_have_no_right_to_add_edit_and_delete')));
            } else {

                $data = Withdrawal::where('id', $id)->first();

                if ($data->status == 0) {
                    $data->status = 1;
                } elseif ($data->status == 1) {
                    $data->status = 0;
                } else {
                    $data->status = 0;
                }
                $data->save();
                return response()->json(array('status' => 200, 'success' => 'Status Changed', 'id' => $data->id, 'Status_Code' => $data->status));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
