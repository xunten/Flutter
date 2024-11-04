<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Classification;
use App\Models\Pratice_Leaderborad;
use App\Models\Pratice_Question;
use App\Models\Question;
use Illuminate\Http\Request;
use Validator;
use Exception;

class ClassificationController extends Controller
{

    public function index(Request $request)
    {
        try {
            $params['data'] = [];
            if ($request->ajax()) {

                $input_search = $request['input_search'];

                if ($input_search != null && isset($input_search)) {
                    $data = Classification::where('level_name', 'LIKE', "%{$input_search}%")->latest()->get();
                } else {
                    $data = Classification::latest()->get();
                }

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = ' <form onsubmit="return confirm(\'Are you sure !!! You want to Delete this Classification ?\');" method="POST"  action="' . route('classification.destroy', [$row->id]) . '">
                            <input type="hidden" name="_token" value="' . csrf_token() . '">
                            <input type="hidden" name="_method" value="DELETE">
                            <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';

                        $btn = '<div class="d-flex justify-content-around" title="Edit">';
                        $btn .= '<a class="edit-delete-btn edit_classification" title="Edit" data-toggle="modal" href="#EditModel" data-id="' . $row->id . '" data-level_name="' . $row->level_name . '" data-level_order="' . $row->level_order . '">';
                        $btn .= '<i class="fa-solid fa-pen-to-square fa-xl"></i>';
                        $btn .= '</a>';
                        $btn .= $delete;
                        $btn .= '</a></div>';
                        return $btn;
                    })
                    ->make(true);
            }
            return view('admin.classification.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'level_name' => 'required|min:2',
                'level_order' => 'required',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $insert = new Classification();
            $insert->level_name = $request->level_name;
            $insert->level_order = $request->level_order;

            if ($insert->save()) {
                return response()->json(array('status' => 200, 'success' => __('Label.success_add_classification')));
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.error_add_classification')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function update(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'level_name' => 'required|min:2',
                'level_order' => 'required',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $user = Classification::where('id', $request->id)->first();

            if (isset($user->id)) {
                $user->level_name = $request->level_name;
                $user->level_order = $request->level_order;
                if ($user->save()) {
                    return response()->json(array('status' => 200, 'success' => __('Label.success_edit_classification')));
                } else {
                    return response()->json(array('status' => 400, 'errors' => __('Label.error_edit_classification')));
                }
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function destroy($id)
    {
        try {
            $data = Classification::where('id', $id)->first();
            $question = Question::where('question_level_master_id', $id)->first();
            $pratice_question = Pratice_Question::where('question_level_master_id', $id)->first();
            $pratice_leaderborad = Pratice_Leaderborad::where('question_level_master_id', '$id')->first();

            if ($question !== null) {
                return back()->with('error', __('Label.This Classification is used on some other table so you can not remove it.'));
            } elseif ($pratice_leaderborad !== null) {
                return back()->with('error', __('Label.This Classification is used on some other table so you can not remove it.'));
            } elseif ($pratice_question !== null) {
                return back()->with('error', __('Label.This Classification is used on some other table so you can not remove it.'));
            }
            $data->delete();

            return redirect()->route('classification.index')->with('success', 'Classification Delete Successfully.');
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
