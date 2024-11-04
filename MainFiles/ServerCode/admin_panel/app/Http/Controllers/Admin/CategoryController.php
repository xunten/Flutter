<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Pratice_Leaderborad;
use App\Models\Pratice_Question;
use App\Models\Question;
use App\Models\Common;
use Illuminate\Http\Request;
use Validator;
use Exception;

class CategoryController extends Controller
{
    private $folder = "category";
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
                    $data = Category::where('name', 'LIKE', "%{$input_search}%")->latest()->get();
                } else {
                    $data = Category::latest()->get();
                }

                $this->common->imageNameToUrl($data, 'image', $this->folder);

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = ' <form onsubmit="return confirm(\'Are you sure !!! You want to Delete this Category ?\');" method="POST"  action="' . route('category.destroy', [$row->id]) . '">
                            <input type="hidden" name="_token" value="' . csrf_token() . '">
                            <input type="hidden" name="_method" value="DELETE">
                            <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';

                        $btn = '<div class="d-flex justify-content-around" title="Edit">';
                        $btn .= '<a class="edit-delete-btn edit_category" title="Edit" data-toggle="modal" href="#EditModel" data-id="' . $row->id . '" data-name="' . $row->name . '" data-image="' . $row->image . '">';
                        $btn .= '<i class="fa-solid fa-pen-to-square fa-xl"></i>';
                        $btn .= '</a>';
                        $btn .= $delete;
                        $btn .= '</a></div>';
                        return $btn;
                    })
                    ->make(true);
            }
            return view('admin.category.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'name' => 'required|min:2',
                'image' => 'required|image|mimes:jpeg,png,jpg|max:2048',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $requestData = $request->all();
            if (isset($requestData['image'])) {
                $files = $requestData['image'];
                $requestData['image'] = $this->common->saveImage($files, $this->folder);
            }

            $category_data = Category::updateOrCreate(['id' => $requestData['id']], $requestData);
            if (isset($category_data->id)) {
                return response()->json(array('status' => 200, 'success' => __('Label.success_add_category')));
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.error_add_category')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function update($id, Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'name' => 'required|min:2',
                'image' => 'image|mimes:jpeg,png,jpg|max:2048',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $requestData = $request->all();

            if (isset($requestData['image'])) {
                $files = $requestData['image'];
                $requestData['image'] = $this->common->saveImage($files, $this->folder);

                $this->common->deleteImageToFolder($this->folder, basename($requestData['old_image']));
            }
            unset($requestData['old_image']);

            $Category_data = Category::updateOrCreate(['id' => $requestData['id']], $requestData);
            if (isset($Category_data->id)) {
                return response()->json(array('status' => 200, 'success' => __('Label.success_edit_category')));
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.error_edit_category')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function destroy($id)
    {
        try {

            $category = Category::where('id', $id)->first();
            $question = Question::where('category_id', $id)->first();
            $pratice_question = Pratice_Question::where('category_id', $id)->first();
            $pratice_leaderborad = Pratice_Leaderborad::where('category_id', '$id')->first();

            if ($question) {
                return back()->with('error', __('Label.This Category is used on some other table so you can not remove it.'));
            } elseif ($pratice_leaderborad) {
                return back()->with('error', __('Label.This Category is used on some other table so you can not remove it.'));
            } elseif ($pratice_question) {
                return back()->with('error', __('Label.This Category is used on some other table so you can not remove it.'));
            }

            if (isset($category)) {
                $this->common->deleteImageToFolder($this->folder, $category['image']);
                $category->delete();
            }

            return redirect()->route('category.index')->with('success', 'Category Delete Successfully.');
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
