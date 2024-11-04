<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Contest;
use App\Models\Level;
use App\Models\Pratice_Leaderborad;
use App\Models\Pratice_Question;
use App\Models\Question;
use Illuminate\Http\Request;
use Validator;
use Exception;

class LevelController extends Controller
{
    public function index(Request $request)
    {
        try {
            $params['data'] = [];
            if ($request->ajax()) {

                $input_search = $request['input_search'];

                if ($input_search != null && isset($input_search)) {
                    $data = Level::where('name', 'LIKE', "%{$input_search}%")->latest()->get();
                } else {
                    $data = Level::latest()->get();
                }

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = ' <form onsubmit="return confirm(\'Are you sure !!! You want to Delete this Level ?\');" method="POST"  action="' . route('level.destroy', [$row->id]) . '">
                                <input type="hidden" name="_token" value="' . csrf_token() . '">
                                <input type="hidden" name="_method" value="DELETE">
                                <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';

                        $btn = '<div class="d-flex justify-content-around" title="Edit">';
                        $btn .= '<a class="edit-delete-btn edit_level" title="Edit" data-toggle="modal" href="#EditModel" data-id="' . $row->id . '" data-name="' . $row->name . '" data-level_order="' . $row->level_order . '" data-score="' . $row->score . '" data-win_question_count="' . $row->win_question_count . '" data-total_question="' . $row->total_question . '" >';
                        $btn .= '<i class="fa-solid fa-pen-to-square fa-xl"></i>';
                        $btn .= '</a>';
                        $btn .= $delete;
                        $btn .= '</a></div>';
                        return $btn;
                    })
                    ->make(true);
            }
            return view('admin.level.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'name' => 'required|min:2',
                'level_order' => 'required',
                'score' => 'required',
                'total_question' => 'required',
                'win_question_count' => 'required',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $level = new Level();
            $level->name = $request->name;
            $level->level_order = $request->level_order;
            $level->score = $request->score;
            $level->total_question = $request->total_question;
            $level->win_question_count = $request->win_question_count;

            if ($level->save()) {
                return response()->json(array('status' => 200, 'success' => __('Label.success_add_level')));
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.error_add_level')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function update(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'name' => 'required|min:2',
                'level_order' => 'required',
                'score' => 'required',
                'total_question' => 'required',
                'win_question_count' => 'required',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $level = Level::where('id', $request->id)->first();
            if (isset($level->id)) {

                $level->name = $request->name;
                $level->level_order = $request->level_order;
                $level->score = $request->score;
                $level->total_question = $request->total_question;
                $level->win_question_count = $request->win_question_count;

                if ($level->save()) {
                    return response()->json(array('status' => 200, 'success' => __('Label.success_edit_level')));
                } else {
                    return response()->json(array('status' => 400, 'errors' => __('Label.error_edit_level')));
                }
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function destroy($id)
    {
        try {
            $level = Level::where('id', $id)->first();
            $contest = Contest::where('level_id', $id)->first();
            $pratice_leaderborad = Pratice_Leaderborad::where('level_id', $id)->first();
            $pratice_question = Pratice_Question::where('level_id', $id)->first();
            $question = Question::where('level_id', $id)->first();

            if ($contest !== null) {
                return back()->with('error', __('Label.This Level is used on some other table so you can not remove it.'));
            } elseif ($question) {
                return back()->with('error', __('Label.This Level is used on some other table so you can not remove it.'));
            } elseif ($pratice_leaderborad) {
                return back()->with('error', __('Label.This Level is used on some other table so you can not remove it.'));
            } elseif ($pratice_question) {
                return back()->with('error', __('Label.This Level is used on some other table so you can not remove it.'));
            }
            $level->delete();

            return redirect()->route('level.index')->with('success', 'Level Delete Successfully.');
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
