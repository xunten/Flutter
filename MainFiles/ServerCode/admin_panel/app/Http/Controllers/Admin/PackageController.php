<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\General_Setting;
use App\Models\Subscription_Plan;
use App\Models\Common;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Validator;
use Exception;

class PackageController extends Controller
{
    private $folder = "subscription";
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
                    $data = Subscription_Plan::where('name', 'LIKE', "%{$input_search}%")->latest()->get();
                } else {
                    $data = Subscription_Plan::latest()->get();
                }

                $this->common->imageNameToUrl($data, 'image', $this->folder);

                return DataTables()::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function ($row) {
                        $delete = ' <form onsubmit="return confirm(\'Are you sure !!! You want to Delete this Package ?\');" method="POST"  action="' . route('package.destroy', [$row->id]) . '">
                                <input type="hidden" name="_token" value="' . csrf_token() . '">
                                <input type="hidden" name="_method" value="DELETE">
                                <button type="submit" class="edit-delete-btn" style="outline: none;" title="Delete"><i class="fa-solid fa-trash-can fa-xl"></i></button></form>';

                        $btn = '<div class="d-flex justify-content-around" title="Edit">';
                        $btn .= '<a href="' . route('package.edit', [$row->id]) . '" class="edit-delete-btn">';
                        $btn .= '<i class="fa-solid fa-pen-to-square fa-xl"></i>';
                        $btn .= '</a>';
                        $btn .= $delete;
                        $btn .= '</a></div>';
                        return $btn;
                    })
                    ->rawColumns(['action'])
                    ->make(true);
            }
            return view('admin.package.index', $params);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function create()
    {
        try {
            $type = General_Setting::get();
            foreach ($type as $key => $value) {
                if ($value->key == "currency") {
                    $CType = $value;
                    break;
                } else {
                    $CType = "";
                }
            }
            if ($CType) {
                return view('admin.package.add', ['type' => $CType]);
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'name' => 'required|min:2',
                'price' => 'required|numeric|min:0',
                'point' => 'required|numeric|min:0',
                'image' => 'required|image|mimes:jpeg,png,jpg|max:2048',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $package = new Subscription_Plan();
            $package->name = $request->name;
            $package->price = $request->price;
            $package->point = $request->point;
            $package->currency_type = currency_code();
            $package->android_product_package = isset($request->android_product_package) ? $request->android_product_package : "";
            $package->ios_product_package = isset($request->ios_product_package) ? $request->ios_product_package : "";
            if (isset($request->image)) {
                $files = $request->image;
                $package->image = $this->common->saveImage($files, $this->folder);
            }

            if ($package->save()) {
                return response()->json(array('status' => 200, 'success' => __('Label.success_add_package')));
            } else {
                return response()->json(array('status' => 400, 'errors' => __('Label.errror_add_package')));
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function edit($id)
    {
        try {
            $params['result'] = Subscription_Plan::where('id', $id)->first();

            if ($params['result'] != null) {

                $this->common->imageNameToUrl(array($params['result']), 'image', $this->folder);

                return view('admin.package.edit', $params);
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
                'name' => 'required|min:2',
                'price' => 'required|numeric|min:0',
                'point' => 'required|numeric|min:0',
                'image' => 'image|mimes:jpeg,png,jpg|max:2048',
            ]);
            if ($validator->fails()) {
                $errs = $validator->errors()->all();
                return response()->json(array('status' => 400, 'errors' => $errs));
            }

            $package = Subscription_Plan::where('id', $request->id)->first();
            if (isset($package->id)) {
                $package->name = $request->name;
                $package->price = $request->price;
                $package->point = $request->point;
                $package->currency_type = currency_code();
                $package->android_product_package = isset($request->android_product_package) ? $request->android_product_package : "";
                $package->ios_product_package = isset($request->ios_product_package) ? $request->ios_product_package : "";
                if (isset($request->image)) {
                    $files = $request->image;
                    $package->image = $this->common->saveImage($files, $this->folder);

                    $this->common->deleteImageToFolder($this->folder, basename($request->old_image));
                }

                if ($package->save()) {
                    return response()->json(array('status' => 200, 'success' => __('Label.success_edit_package')));
                } else {
                    return response()->json(array('status' => 400, 'errors' => __('Label.error_edit_package')));
                }
            }
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
    public function destroy($id)
    {
        try {
            $package = Subscription_Plan::where('id', $id)->first();
            $transaction = Transaction::where('plan_subscription_id', $id)->first();

            if ($transaction !== null) {
                return back()->with('error', __('Label.This Package is used on some other table so you can not remove it.'));
            }

            if (isset($package)) {
                $this->common->deleteImageToFolder($this->folder, $package['image']);
                $package->delete();
            }
            return redirect()->route('package.index')->with('success', __('Label.Package Delete Successfully.'));
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
