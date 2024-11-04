@extends('layout.page-app')
@section('page_title', __('Label.general_setting'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.general_setting')}}</h1>

            <div class="border-bottom row mb-3">
                <div class="col-sm-12">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a></li>
                        <li class="breadcrumb-item active" aria-current="page">{{__('Label.general_setting')}}</li>
                    </ol>
                </div>
            </div>

            <ul class="nav nav-pills custom-tabs inline-tabs" id="pills-tab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="app-tab" data-toggle="tab" href="#app" role="tab" aria-controls="app" aria-selected="true">APP SETTINGS</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="change-password-tab" data-toggle="tab" href="#change-password" role="tab" aria-controls="change-password" aria-selected="true">{{__('Label.CHANGE PASSWORD')}}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="social-tab" data-toggle="tab" href="#social" role="tab" aria-controls="social" aria-selected="false">SOCIAl SETTING</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="admob-tab" data-toggle="tab" href="#admob" role="tab" aria-controls="admob" aria-selected="false">{{__('Label.ADMOB')}}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="facebook-ads-tab" data-toggle="tab" href="#facebook-ads" role="tab" aria-controls="facebook-ads" aria-selected="false">{{__('Label.FACEBOOK ADS')}}</a>
                </li>
            </ul>

            <div class="tab-content" id="pills-tabContent">
                <div class="tab-pane fade show active" id="app" role="tabpanel" aria-labelledby="app-tab">
                    <div class="app-right-btn">
                        <a href="{{ route('smtp.index')}}" class="btn btn-default">EMAIL SETTINGS [SMTP]</a>
                    </div>
                    <div class="card custom-border-card">
                        <h5 class="card-header">App Configrations</h5>
                        <div class="card-body">
                            <div class="input-group">
                                <div class="col-2">
                                    <label class="ml-5 pt-3" style="font-size:16px; font-weight:500; color:#1b1b1b">API Path</label>
                                </div>
                                <input type="text" readonly value="{{url('/')}}/api/" name="api_path" class="form-control" id="api_path">
                                <div class="input-group-text ml-2" onclick="Function_Api_path()" title="Copy">
                                    <i class="fa-solid fa-copy fa-2xl"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card custom-border-card">
                        <h5 class="card-header">{{__('Label.App Settings')}}</h5>
                        <div class="card-body">
                            <form id="app_setting" enctype="multipart/form-data">
                                @csrf
                                <div class="form-row">
                                    <div class="col-md-9">
                                        <div class="form-row">
                                            <div class="form-group col-md-4">
                                                <label>{{__('Label.App Name')}}</label>
                                                <input type="text" name="app_name" value="@if($result && isset($result['app_name'])){{$result['app_name']}}@endif" class="form-control" placeholder="Enter App Name" autofocus>
                                            </div>
                                            <div class="form-group col-md-4">
                                                <label>{{__('Label.Host Email')}}</label>
                                                <input type="email" name="host_email" value="@if($result && isset($result['host_email'])){{$result['host_email']}}@endif" class="form-control" placeholder="Enter Host Email">
                                            </div>
                                            <div class="form-group col-md-4">
                                                <label>{{__('Label.App Version')}}</label>
                                                <input type="text" name="app_version" value="@if($result && isset($result['app_version'])){{$result['app_version']}}@endif" class="form-control" placeholder="Enter App Version">
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="form-group col-md-4">
                                                <label>{{__('Label.Author')}}</label>
                                                <input type="text" name="author" value=" @if($result && isset($result['author'])){{$result['author']}}@endif" class="form-control" placeholder="Enter Author">
                                            </div>
                                            <div class="form-group col-md-4">
                                                <label>{{__('Label.Email')}} </label>
                                                <input type="email" name="email"  value="@if($result && isset($result['email'])){{$result['email']}}@endif" class="form-control" placeholder="Enter Email">
                                            </div>
                                            <div class="form-group  col-md-4">
                                                <label> {{__('Label.Contact')}} </label>
                                                <input type="text" name="contact" value="@if($result && isset($result['contact'])){{$result['contact']}}@endif" class="form-control" placeholder="Enter Contact">
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="form-group col-md-4">
                                                <label>{{__('Label.WEBSITE')}}</label>
                                                <input type="text" name="website" value="@if($result && isset($result['website'])){{$result['website']}}@endif" class="form-control" placeholder="Enter Your Website">
                                            </div>
                                            <div class="form-group col-md-8">
                                                <label>{{__('Label.APP DESCRIPATION')}}</label>
                                                <textarea name="app_desripation" rows="1" class="form-control" placeholder="Enter App Desripation">@if($result && isset($result['app_desripation'])){{$result['app_desripation']}}@endif</textarea>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group ml-5">
                                            <label class="ml-5">App Icon</label>
                                            <div class="avatar-upload ml-5">
                                                <div class="avatar-edit">
                                                    <input type='file' name="app_logo" id="imageUpload" accept=".png, .jpg, .jpeg" />
                                                    <label for="imageUpload" title="Select File"></label>
                                                </div>
                                                <div class="avatar-preview">
                                                    <img src="{{$result['app_logo']}}" alt="upload_img.png" id="imagePreview">
                                                </div>
                                            </div>
                                            <!-- <label class="mt-3 ml-5 text-gray">Maximum size 2MB.</label> -->
                                            <input type="hidden" name="old_app_logo" value="{{$result['app_logo']}}">
                                        </div>
                                    </div>
                                </div>
                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="app_setting()">{{__('Label.SAVE')}}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="card custom-border-card">
                        <h5 class="card-header">Currency Settings</h5>
                        <div class="card-body">
                            <form id="save_currency">
                                @csrf
                                <div class="form-row">
                                    <div class="form-group col-md-3">
                                        <label>{{__('Label.Currency Name')}} </label>
                                        <input type="text" name="currency" class="form-control" value="{{$result['currency']}}" placeholder="Enter Currency Name">
                                    </div>
                                    <div class="form-group col-md-3">
                                        <label> {{__('Label.Currency Code')}} </label>
                                        <input type="text" name="currency_code" class="form-control" value="{{$result['currency_code']}}" placeholder="Enter Currency Code">
                                    </div>
                                </div>
                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="save_currency()">{{__('Label.SAVE')}}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="change-password" role="tabpanel" aria-labelledby="change-password-tab">
                    <div class="card custom-border-card">
                        <h5 class="card-header">{{__('Label.Change Password')}}</h5>
                        <div class="card-body">
                            <div class="form-group">
                                <form id="change_password">
                                    @csrf
                                    <input type="hidden" name="admin_id" value="1">
                                    <div class="form-row">
                                        <div class="form-group col-md-4">
                                            <label>{{__('Label.New Password')}}</label>
                                            <input type="password" name="password" class="form-control" placeholder="Enter New Password">
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-group col-md-4">
                                            <label>{{__('Label.Confirm Password')}}</label>
                                            <input type="password" name="confirm_password" class="form-control" placeholder="Enter Confirm Password">
                                        </div>
                                    </div>
                                    <div class="border-top pt-3 text-right">
                                        <button type="button" class="btn btn-default mw-120" onclick="change_password()">{{__('Label.SAVE')}}</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="social" role="tabpanel" aria-labelledby="social-tab">
                    <div class="card custom-border-card">
                        <h5 class="card-header">Social Links</h5>
                        <div class="card-body">
                            <form id="social_link" enctype="multipart/form-data">
                                @csrf
                                <div class="row col-md-12">
                                    <div class="form-group col-md-3">
                                        <label>Name</label>
                                        <input type="text" name="name[]" class="form-control" placeholder="Enter URL Name">
                                    </div>
                                    <div class="form-group col-md-3">
                                        <label>URL</label>
                                        <input type="url" name="url[]" class="form-control" placeholder="Enter URL">
                                    </div>
                                    <div class="form-group col-md-3">
                                        <label>Icon</label>
                                        <input type="file" name="image[]" class="form-control import-file social_img" id="social_img">
                                        <input type="hidden" name="old_image[]" value="">
                                    </div>
                                    <div class="form-group col-md-2">
                                        <div class="custom-file">
                                            <img src="{{asset('assets/imgs/upload_img.png')}}" style="height: 90px; width: 90px;" class="img-thumbnail" id="link_img_social_img">
                                        </div>
                                    </div>
                                    <div class="col-md-1 mt-2">
                                        <div class="flex-grow-1 px-5 d-inline-flex">
                                            <div class="change mr-3 mt-4" id="add_btn" title="Add More">
                                                <a class="btn btn-success add-more text-white" onclick="add_more_link()">+</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                @for ($i=0; $i < count($social_link); $i++)
                                    <div class="social_part">
                                        <div class="row col-lg-12">
                                            <div class="form-group col-md-3">
                                                <label>Name</label>
                                                <input type="text" name="name[]" value="{{ $social_link[$i]['name'] }}" class="form-control" placeholder="Enter URL Name">
                                            </div>
                                            <div class="form-group col-md-3">
                                                <label>URL</label>
                                                <input type="url" name="url[]" value="{{ $social_link[$i]['url'] }}" class="form-control" placeholder="Enter URL">
                                            </div>
                                            <div class="form-group col-md-3">
                                                <label>Icon</label>
                                                <input type="file" name="image[]" class="form-control import-file social_img" id="social_img_{{$i}}">
                                                <input type="hidden" name="old_image[]" value="{{ $social_link[$i]['image'] }}">
                                            </div>
                                            <div class="form-group col-md-2">
                                                <div class="custom-file">
                                                    <?php $app = Get_Image('app', $social_link[$i]['image']); ?>
                                                    <img src="{{$app}}" style="height: 90px; width: 90px;" class="img-thumbnail" id="link_img_social_img_{{$i}}">
                                                </div>
                                            </div>
                                            <div class="col-md-1 mt-2">
                                                <div class="flex-grow-1 px-5 d-inline-flex">
                                                    <div class="change mr-3 mt-4" id="add_btn" title="Remove">
                                                        <a class="btn btn-danger text-white remove_link">-</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                @endfor               
                                
                                <div class="after-add-more"></div>

                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="social_link()">{{__('Label.SAVE')}}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="admob" role="tabpanel" aria-labelledby="admob-tab">
                    <div class="card custom-border-card mt-3">
                        <h5 class="card-header">Android Settings</h5>
                        <div class="card-body">
                            <form id="admob_android">
                                @csrf
                                <div class="row">
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="banner_ad">{{__('Label.Banner Ad')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="banner_ad" name="banner_ad" class="custom-control-input" {{ ($result['banner_ad']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="banner_ad">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="banner_ad1" name="banner_ad" class="custom-control-input" {{ ($result['banner_ad']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="banner_ad1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="interstital_ad">{{__('Label.Interstital Ad')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="interstital_ad" name="interstital_ad" class="custom-control-input" {{ ($result['interstital_ad']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="interstital_ad">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="interstital_ad1" name="interstital_ad" class="custom-control-input" {{ ($result['interstital_ad']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="interstital_ad1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="reward_ad">Reward Ad</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="reward_ad" name="reward_ad" class="custom-control-input" {{ ($result['reward_ad']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="reward_ad">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="reward_ad1" name="reward_ad" class="custom-control-input" {{ ($result['reward_ad']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="reward_ad1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>{{__('Label.Banner Ad ID')}}</label>
                                            <input type="text" name="banner_adid" class="form-control" placeholder="Enter Banner Ad ID" value="{{$result['banner_adid']}}">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>{{__('Label.Interstital Ad ID')}}</label>
                                            <input type="text" name="interstital_adid" class="form-control" placeholder="Enter interstital Ad ID" value="{{$result['interstital_adid']}}">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Reward Ad ID</label>
                                            <input type="text" name="reward_adid" class="form-control" placeholder="Enter Reward Ad ID" value="{{$result['reward_adid']}}">
                                        </div>
                                    </div>

                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label></label>
                                            &nbsp;
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Interstital Ad Click</label>
                                            <input type="text" name="interstital_adclick" class="form-control" placeholder="Enter Interstital Ad Click" value="{{$result['interstital_adclick']}}">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Reward Ad Click</label>
                                            <input type="text" name="reward_adclick" class="form-control" placeholder="Enter Reward Ad Click" value="{{$result['reward_adclick']}}">
                                        </div>
                                    </div>
                                </div>
                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="admob_android()">{{__('Label.SAVE')}}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="card custom-border-card mt-3">
                        <h5 class="card-header">IOS Settings</h5>
                        <div class="card-body">
                            <form id="admob_ios">
                                @csrf
                                <div class="row">
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="ios_banner_ad">{{__('Label.Banner Ad')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="ios_banner_ad" name="ios_banner_ad" class="custom-control-input" {{ ($result['ios_banner_ad']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="ios_banner_ad">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="ios_banner_ad1" name="ios_banner_ad" class="custom-control-input" {{ ($result['ios_banner_ad']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="ios_banner_ad1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="ios_interstital_ad">{{__('Label.Interstital Ad')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="ios_interstital_ad" name="ios_interstital_ad" class="custom-control-input" {{ ($result['ios_interstital_ad']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="ios_interstital_ad">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="ios_interstital_ad1" name="ios_interstital_ad" class="custom-control-input" {{ ($result['ios_interstital_ad']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="ios_interstital_ad1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="ios_reward_ad">Reward Ad</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="ios_reward_ad" name="ios_reward_ad" class="custom-control-input" {{ ($result['ios_reward_ad']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="ios_reward_ad">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="ios_reward_ad1" name="ios_reward_ad" class="custom-control-input" {{ ($result['ios_reward_ad']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="ios_reward_ad1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>{{__('Label.Banner Ad ID')}}</label>
                                            <input type="text" name="ios_banner_adid" class="form-control" placeholder="Enter Banner Ad ID" value="{{$result['ios_banner_adid']}}">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>{{__('Label.Interstital Ad ID')}}</label>
                                            <input type="text" name="ios_interstital_adid" class="form-control" placeholder="Enter interstital Ad ID" value="{{$result['ios_interstital_adid']}}">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Reward Ad ID</label>
                                            <input type="text" name="ios_reward_adid" class="form-control" placeholder="Enter Reward Ad ID" value="{{$result['ios_reward_adid']}}">
                                        </div>
                                    </div>

                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label></label>
                                            &nbsp;
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Interstital Ad Click</label>
                                            <input type="text" name="ios_interstital_adclick" class="form-control" placeholder="Enter Interstital Ad Click" value="{{$result['ios_interstital_adclick']}}">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Reward Ad Click</label>
                                            <input type="text" name="ios_reward_adclick" class="form-control" placeholder="Enter Reward Ad Click" value="{{$result['ios_reward_adclick']}}">
                                        </div>
                                    </div>
                                </div>
                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="admob_ios()">{{__('Label.SAVE')}}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="facebook-ads" role="tabpanel" aria-labelledby="facebook-ads-tab">
                    <div class="card custom-border-card mt-3">
                        <h5 class="card-header">Android Settings</h5>
                        <div class="card-body">
                            <form id="fbad">
                                @csrf
                                <div class="row">
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="fb_native_status">{{__('Label.Native Status')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_native_status" name="fb_native_status" class="custom-control-input" {{ ($result['fb_native_status']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="fb_native_status">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_native_status1" name="fb_native_status" class="custom-control-input" {{ ($result['fb_native_status']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="fb_native_status1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="fb_banner_status">{{__('Label.Banner Status')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_banner_status" name="fb_banner_status" class="custom-control-input" {{($result['fb_banner_status']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="fb_banner_status">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_banner_status1" name="fb_banner_status" class="custom-control-input" {{ ($result['fb_banner_status']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="fb_banner_status1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="fb_interstiatial_status">{{__('Label.Interstiatial Status')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_interstiatial_status" name="fb_interstiatial_status" class="custom-control-input" {{($result['fb_interstiatial_status']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="fb_interstiatial_status">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_interstiatial_status1" name="fb_interstiatial_status" class="custom-control-input" {{ ($result['fb_interstiatial_status']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="fb_interstiatial_status1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Native Key</label>
                                            <input type="text" name="fb_native_id" class="form-control" value="{{$result['fb_native_id']}}" placeholder="Enter Native Key">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Banner Key</label>
                                            <input type="text" name="fb_banner_id" class="form-control" value="{{$result['fb_banner_id']}}" placeholder="Enter Banner key">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Interstiatial Key</label>
                                            <input type="text" name="fb_interstiatial_id" class="form-control" value="{{$result['fb_interstiatial_id']}}" placeholder="Enter Interstiatial Key">
                                        </div>
                                    </div>
                                </div>
                                <hr>
                                <div class="row">
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group col-lg-6">
                                            <label for="fb_rewardvideo_status">{{__('Label.RewardVideo Status')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_rewardvideo_status" name="fb_rewardvideo_status" class="custom-control-input" {{($result['fb_rewardvideo_status']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="fb_rewardvideo_status">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_rewardvideo_status1" name="fb_rewardvideo_status" class="custom-control-input" {{ ($result['fb_rewardvideo_status']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="fb_rewardvideo_status1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group col-lg-6">
                                            <label for="fb_native_full_status">{{__('Label.Native Full Status')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_native_full_status" name="fb_native_full_status" class="custom-control-input" {{($result['fb_native_full_status']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="fb_native_full_status">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_native_full_status1" name="fb_native_full_status" class="custom-control-input" {{ ($result['fb_native_full_status']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="fb_native_full_status1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Rewardvideo Status Key</label>
                                            <input type="text" name="fb_rewardvideo_id" class="form-control" value="{{$result['fb_rewardvideo_id']}}" placeholder="Enter Reward Video Status Key">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Native Full Key</label>
                                            <input type="text" name="fb_native_full_id" class="form-control" value="{{$result['fb_native_full_id']}}" placeholder="Enter Native Full Key">
                                        </div>
                                    </div>
                                </div>
                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="fbad()">{{__('Label.SAVE')}}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="card custom-border-card mt-3">
                        <h5 class="card-header">IOS Settings</h5>
                        <div class="card-body">
                            <form id="fbad_ios">
                                @csrf
                                <div class="row">
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="fb_ios_native_status">{{__('Label.Native Status')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_ios_native_status" name="fb_ios_native_status" class="custom-control-input" {{ ($result['fb_ios_native_status']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="fb_ios_native_status">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_ios_native_status1" name="fb_ios_native_status" class="custom-control-input" {{ ($result['fb_ios_native_status']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="fb_ios_native_status1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="fb_ios_banner_status">{{__('Label.Banner Status')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_ios_banner_status" name="fb_ios_banner_status" class="custom-control-input" {{($result['fb_ios_banner_status']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="fb_ios_banner_status">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_ios_banner_status1" name="fb_ios_banner_status" class="custom-control-input" {{ ($result['fb_ios_banner_status']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="fb_ios_banner_status1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label for="fb_ios_interstiatial_status">{{__('Label.Interstiatial Status')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_ios_interstiatial_status" name="fb_ios_interstiatial_status" class="custom-control-input" {{($result['fb_ios_interstiatial_status']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="fb_ios_interstiatial_status">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_ios_interstiatial_status1" name="fb_ios_interstiatial_status" class="custom-control-input" {{ ($result['fb_ios_interstiatial_status']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="fb_ios_interstiatial_status1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Native Key</label>
                                            <input type="text" name="fb_ios_native_id" class="form-control" value="{{$result['fb_ios_native_id']}}" placeholder="Enter Native Key">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Banner Key</label>
                                            <input type="text" name="fb_ios_banner_id" class="form-control" value="{{$result['fb_ios_banner_id']}}" placeholder="Enter Banner Key">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Interstiatial Key</label>
                                            <input type="text" name="fb_ios_interstiatial_id" class="form-control" value="{{$result['fb_ios_interstiatial_id']}}" placeholder="Enter Interstiatial Key">
                                        </div>
                                    </div>
                                </div>
                                <hr>
                                <div class="row">
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group col-lg-6">
                                            <label for="fb_ios_rewardvideo_status">{{__('Label.RewardVideo Status')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_ios_rewardvideo_status" name="fb_ios_rewardvideo_status" class="custom-control-input" {{($result['fb_ios_rewardvideo_status']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="fb_ios_rewardvideo_status">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_ios_rewardvideo_status1" name="fb_ios_rewardvideo_status" class="custom-control-input" {{ ($result['fb_ios_rewardvideo_status']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="fb_ios_rewardvideo_status1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group col-lg-6">
                                            <label for="fb_ios_native_full_status">{{__('Label.Native Full Status')}}</label>
                                            <div class="radio-group">
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_ios_native_full_status" name="fb_ios_native_full_status" class="custom-control-input" {{($result['fb_ios_native_full_status']=='1')? "checked" : "" }} value="1">
                                                    <label class="custom-control-label" for="fb_ios_native_full_status">{{__('Label.Yes')}}</label>
                                                </div>
                                                <div class="custom-control custom-radio">
                                                    <input type="radio" id="fb_ios_native_full_status1" name="fb_ios_native_full_status" class="custom-control-input" {{ ($result['fb_ios_native_full_status']=='0')? "checked" : "" }} value="0">
                                                    <label class="custom-control-label" for="fb_ios_native_full_status1">{{__('Label.No')}}</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Rewardvideo Status Key</label>
                                            <input type="text" name="fb_ios_rewardvideo_id" class="form-control" value="{{$result['fb_ios_rewardvideo_id']}}" placeholder="Enter Reward Video Status Key">
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6 col-md-4">
                                        <div class="form-group">
                                            <label>Native Full Key</label>
                                            <input type="text" name="fb_ios_native_full_id" class="form-control" value="{{$result['fb_ios_native_full_id']}}" placeholder="Enter native Full Key">
                                        </div>
                                    </div>
                                </div>
                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="fbad_ios()">{{__('Label.SAVE')}}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('pagescript')
    <script>
        function Function_Api_path() {
            /* Get the text field */
            var copyText = document.getElementById("api_path");

            /* Select the text field */
            copyText.select();
            copyText.setSelectionRange(0, 99999); /* For mobile devices */

            document.execCommand('copy');

            /* Alert the copied text */
            alert("Copied the API Path: " + copyText.value);
        }

        function app_setting() {
            var formData = new FormData($("#app_setting")[0]);
            $("#dvloader").show();
            $.ajax({
                type: 'POST',
                url: '{{ route("setting.app") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    get_responce_message(resp, 'app_setting', '{{ route("setting") }}');
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
        function save_currency() {
            var formData = new FormData($("#save_currency")[0]);
            $("#dvloader").show();
            $.ajax({
                type: 'POST',
                url: '{{ route("setting.currency") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    $("html, body").animate({scrollTop: 0}, "swing");
                    get_responce_message(resp);
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
        function change_password() {
            var formData = new FormData($("#change_password")[0]);
            $("#dvloader").show();
            $.ajax({
                type: 'POST',
                url: '{{ route("setting.changepassword") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    $("html, body").animate({scrollTop: 0}, "swing");
                    get_responce_message(resp, 'change_password');
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
        function admob_android() {
            var formData = new FormData($("#admob_android")[0]);
            $("#dvloader").show();
            $.ajax({
                type: 'POST',
                url: '{{ route("setting.admob.android") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    $("html, body").animate({scrollTop: 0}, "swing");
                    get_responce_message(resp);
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
        function admob_ios() {
            var formData = new FormData($("#admob_ios")[0]);
            $("#dvloader").show();
            $.ajax({
                type: 'POST',
                url: '{{ route("setting.admob.ios") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    $("html, body").animate({scrollTop: 0}, "swing");
                    get_responce_message(resp);
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
        function fbad() {
            var formData = new FormData($("#fbad")[0]);
            $("#dvloader").show();
            $.ajax({
                type: 'POST',
                url: '{{ route("setting.facebookad.android") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    $("html, body").animate({scrollTop: 0}, "swing");
                    get_responce_message(resp);
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
        function fbad_ios() {
            var formData = new FormData($("#fbad_ios")[0]);
            $("#dvloader").show();
            $.ajax({
                type: 'POST',
                url: '{{ route("setting.facebookad.ios") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    $("html, body").animate({scrollTop: 0}, "swing");
                    get_responce_message(resp);
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }

        // Multipal Img Show 
        $(document).on('change', '.social_img', function(){
            readURL(this, this.id);
        });
        function readURL(input, id) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                 
                reader.onload = function (e) {
                    $('#link_img_'+id).attr('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        // Add Link Part
        var i = -1;
        function add_more_link(){

            var data = '<div class="social_part">';
                data += '<div class="row col-md-12">';
                data += '<div class="form-group col-md-3">';
                data += '<label>Name</label>';
                data += '<input type="text" name="name[]" class="form-control" placeholder="Enter URL Name">';
                data += '</div>';
                data += '<div class="form-group col-md-3">';
                data += '<label>URL</label>';
                data += '<input type="url" name="url[]" class="form-control" placeholder="Enter URL">';
                data += '</div>';
                data += '<div class="form-group col-lg-3">';
                data += '<label>Icon</label>';
                data += '<input type="file" name="image[]" class="form-control import-file social_img" id="social_img_'+i+'">';
                data += '<input type="hidden" name="old_image[]" value="">';
                data += '</div>';
                data += '<div class="form-group col-md-2">';
                data += '<div class="custom-file">';
                data += '<img src="{{asset("assets/imgs/upload_img.png")}}" style="height: 90px; width: 90px;" class="img-thumbnail" id="link_img_social_img_'+i+'">';
                data += '</div>';
                data += '</div>';
                data += '<div class="col-md-1 mt-2">';
                data += '<div class="flex-grow-1 px-5 d-inline-flex">';
                data += '<div class="change mr-3 mt-4" id="add_btn" title="Remove">';
                data += '<a class="btn btn-danger add-more text-white remove_link">-</a>';
                data += '</div>';
                data += '</div>';
                data += '</div>';
                data += '</div>';
                data += '</div>';

            $('.after-add-more').append(data);
            i--;
            $("html, body").animate({ scrollTop: $(document).height() }, "slow");
        }
        // Remove Link Part
        $("body").on("click", ".remove_link", function(e) {
            $(this).parents('.social_part').remove();
        });

        // Save Social Link
        function social_link() {

            var formData = new FormData($("#social_link")[0]);
            $("#dvloader").show();
            $.ajax({
                type: 'POST',
                url: '{{ route("settingSocialLink") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    get_responce_message(resp, 'app_setting', '{{ route("setting") }}');
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
    </script>
@endsection