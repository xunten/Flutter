<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\One_to_One_challenge;
use App\Models\One_to_One_Leaderboard;
use Illuminate\Http\Request;

class OneToOneController extends Controller
{

    public function index(Request $request)
    {
        try {

            $params['data'] = [];
            if ($request->ajax()) {

                if ($request->type == "all") {
                    $data = One_to_One_challenge::with('c_user')->with('j_user')->with('category')->latest()->get();
                } elseif ($request->type == "today") {
                    $data = One_to_One_challenge::select('*')->with('c_user')->with('j_user')->with('category')->whereDate('created_at', date("Y-m-d"))->get();
                } elseif ($request->type == "month") {
                    $data = One_to_One_challenge::select('*')->with('c_user')->with('j_user')->with('category')->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'))->get();
                } else {
                    $data = One_to_One_challenge::with('c_user')->with('j_user')->with('category')->latest()->get();
                }
                return DataTables()::of($data)->addIndexColumn()->make(true);
            }
            return view('admin.one_to_one.index', $params);

        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

    public function leaderboard(Request $request)
    {
        try {
            $params['data'] = [];
            if ($request->ajax()) {

                if ($request->type == "today") {
                    $data = One_to_One_Leaderboard::with('w_user')->with('l_user')->whereDate('created_at', date("Y-m-d"));
                } elseif ($request->type == "month") {
                    $data = One_to_One_Leaderboard::with('w_user')->with('l_user')->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'));
                } else {
                    $data = One_to_One_Leaderboard::with('w_user')->with('l_user');
                }
                $data = $data->orderBy('status', 'DESC')->get();
                return DataTables()::of($data)->addIndexColumn()->make(true);
            }
            return view('admin.one_to_one.leaderboard', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }

}
