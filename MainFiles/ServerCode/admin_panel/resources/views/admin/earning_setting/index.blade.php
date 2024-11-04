@extends('layout.page-app')
@section('page_title', __('Label.Earning Setting'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.Earning Setting')}}</h1>

            <div class="border-bottom row mb-3">
                <div class="col-sm-12">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a></li>
                        <li class="breadcrumb-item active" aria-current="page">{{__('Label.Earning Setting')}}</li>
                    </ol>
                </div>
            </div>

            <ul class="nav nav-pills custom-tabs" id="pills-tab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="earning-setting-tab" data-toggle="pill" href="#earning-setting" role="tab" aria-controls="earning-setting" aria-selected="true">{{__('Label.EARNING SETTING')}}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="set-earning-point-tab" data-toggle="pill" href="#set-earning-point" role="tab" aria-controls="set-earning-point" aria-selected="true">{{__('Label.SET EARNING POINT')}}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="spin-wheel-point-tab" data-toggle="pill" href="#spin-wheel-point" role="tab" aria-controls="spin-wheel-point" aria-selected="true">{{__('Label.SPIN WHEEL POINT')}}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="daily-login-point-tab" data-toggle="pill" href="#daily-login-point" role="tab" aria-controls="daily-login-point" aria-selected="false">{{__('Label.DAILY LOGIN POINT')}}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="get-free-cong-point-tab" data-toggle="pill" href="#get-free-cong-point" role="tab" aria-controls="get-free-cong-point" aria-selected="false">{{__('Label.GET FREE COIN POINT')}}</a>
                </li>
            </ul>

            <div class="tab-content" id="pills-tabContent">
                <div class="tab-pane fade show active" id="earning-setting" role="tabpanel" aria-labelledby="earning-setting-tab">
                    <div class="card custom-border-card">
                        <h5 class="card-header">{{__('Label.Earning Setting')}}</h5>
                        <div class="card-body">
                            <form id="earning_setting" enctype="multipart/form-data">
                                <input type="hidden" name="_token" value="{{ csrf_token() }}">
                                <div class="row col-lg-12">
                                    <div class="form-group col-lg-2">
                                        <label class="ml-2"> {{__('Label.Point')}}</label>
                                        <input type="number" name="earning_point" min="0" class="form-control" value="{{$result['earning_point']}}">
                                    </div>
                                    <div class="form-group col-lg-1">
                                        <label class="d-flex justify-content-center align-items-center">=</label>
                                    </div>
                                    <div class="form-group col-lg-3">
                                        <label class="ml-2">{{__('Label.Amount')}}</label>
                                        <input type="number" name="earning_amount" min="0" class="form-control" value="{{$result['earning_amount']}}">
                                    </div>

                                    <div class="form-group col-lg-2">
                                        <label class="ml-2">Currency</label>
                                        <input type="text" name="currency" readonly class="form-control" value="{{$result['currency']}}">
                                    </div>

                                    <div class="form-group col-lg-4">
                                        <label class="ml-2">{{__('Label.MIN WITHDRAWAL POINTS')}} </label>
                                        <input type="number" name="min_earning_point" min="0" class="form-control" value="{{$result['min_earning_point']}}">
                                    </div>
                                </div>
                                <div class="row col-lg-12">
                                    <div class=" form-group col-lg-2 ">
                                        <label class="ml-2">{{__('Label.Daily Refer Limit')}}</label>
                                        <input type="number" name="daily_refer_limit" min="0" class="form-control" value="{{$result['daily_refer_limit']}}">
                                    </div>

                                    <div class="form-group col-lg-4">
                                        <label class="ml-2">{{__('Label.wallet withdraw visibility')}}</label>
                                        <select name="wallet_withdraw_visibility" class="form-control" id="wallet_withdraw_visibility">
                                            <option value="no" {{ $result['wallet_withdraw_visibility'] == "no"  ? 'selected' : ''}}> No</option>
                                            <option value="yes" {{ $result['wallet_withdraw_visibility'] == "yes"  ? 'selected' : ''}}> Yes</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="earning_setting()">{{__('Label.SAVE')}}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="set-earning-point" role="tabpanel" aria-labelledby="set-earning-point-tab">
                    <div class="card custom-border-card">
                        <h5 class="card-header">{{__('Label.Set Earning Point')}}</h5>
                        <div class="card-body">
                            <div class="">
                                <div class="form-group">
                                    <form id="earnpoint_setting" enctype="multipart/form-data">
                                        <input type="hidden" name="_token" value="{{ csrf_token() }}">
                                        <table class="table table-bordered table-striped text-center">
                                            <thead>
                                                <tr style="background: #F9FAFF;">
                                                    <th width="50%">{{__('Label.Activity Name')}} </th>
                                                    <th>{{__('Label.Point')}}</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>{{__('Label.Level')}}</td>
                                                    <td><input type="number" name="Level" class="form-control" min="0" value="{{$earnpoint['Level']}}"></td>
                                                </tr>
                                                <tr>
                                                    <td>{{__('Label.Registration')}}</td>
                                                    <td><input type="number" name="Registration" class="form-control" min="0" value="{{$earnpoint['Registration']}}"></td>
                                                </tr>
                                                <tr>
                                                    <td>{{__('Label.ReferUser')}}</td>
                                                    <td><input type="number" name="ReferUser" class="form-control" min="0" value="{{$earnpoint['ReferUser']}}"></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <br><br>
                                        <div class="border-top pt-3 text-right">
                                            <button type="button" class="btn btn-default mw-120" onclick="earnpoint_setting()">{{__('Label.SAVE')}}</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="spin-wheel-point" role="tabpanel" aria-labelledby="spin-wheel-point-tab">
                    <div class="card custom-border-card">
                        <h5 class="card-header">{{__('Label.Spin Wheel Point')}}</h5>
                        <div class="card-body">
                            <form id="spinwheelpoint">
                                <input type="hidden" name="_token" value="{{ csrf_token() }}">
                                <table class="table table-bordered table-striped text-center">
                                    <thead>
                                        <tr style="background: #F9FAFF;">
                                            <th width="50%"> {{__('Label.Activity Name')}} </th>
                                            <th> {{__('Label.Point')}}</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>1</td>
                                            <td><input type="number" name="1" class="form-control" min="0" value="{{$earn_point['1']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>2</td>
                                            <td><input type="number" name="2" class="form-control" min="0" value="{{$earn_point['2']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>3</td>
                                            <td><input type="number" name="3" class="form-control" min="0" value="{{$earn_point['3']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>4</td>
                                            <td><input type="number" name="4" class="form-control" min="0" value="{{$earn_point['4']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>5</td>
                                            <td><input type="number" name="5" class="form-control" min="0" value="{{$earn_point['5']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>6</td>
                                            <td><input type="number" name="6" class="form-control" min="0" value="{{$earn_point['6']}}"></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <br><br>
                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="spinwheelpoint()">{{__('Label.SAVE')}}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="daily-login-point" role="tabpanel" aria-labelledby="daily-login-point-tab">
                    <div class="card custom-border-card mt-3">
                        <h5 class="card-header">{{__('Label.Daily Login Point')}}</h5>
                        <div class="card-body">
                            <form id="daily_login" enctype="multipart/form-data">
                                <input type="hidden" name="_token" value="{{ csrf_token() }}">
                                <table class="table table-bordered table-striped text-center">
                                    <thead>
                                        <tr style="background: #F9FAFF;">
                                            <th width="50%"> {{__('Label.Activity Name')}} </th>
                                            <th> {{__('Label.Point')}}</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>{{__('Label.Day-1')}}</td>
                                            <td><input type="number" name="Day-1" class="form-control" min="0" value="{{$earn_point['Day-1']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>{{__('Label.Day-2')}}</td>
                                            <td><input type="number" name="Day-2" class="form-control" min="0" value="{{$earn_point['Day-2']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>{{__('Label.Day-3')}}</td>
                                            <td><input type="number" name="Day-3" class="form-control" min="0" value="{{$earn_point['Day-3']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>{{__('Label.Day-4')}}</td>
                                            <td><input type="number" name="Day-4" class="form-control" min="0" value="{{$earn_point['Day-4']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>{{__('Label.Day-5')}}</td>
                                            <td><input type="number" name="Day-5" class="form-control" min="0" value="{{$earn_point['Day-5']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>{{__('Label.Day-6')}}</td>
                                            <td><input type="number" name="Day-6" class="form-control" min="0" value="{{$earn_point['Day-6']}}"></td>
                                        </tr>
                                        <tr>
                                            <td>{{__('Label.Day-7')}}</td>
                                            <td><input type="number" name="Day-7" class="form-control" min="0" value="{{$earn_point['Day-7']}}"></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <br><br>
                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="daily_login()">{{__('Label.SAVE')}}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="get-free-cong-point" role="tabpanel" aria-labelledby="get-free-cong-point-tab">
                    <div class="card custom-border-card mt-3">
                        <h5 class="card-header">{{__('Label.Get Free Coin Point')}}</h5>
                        <div class="card-body">
                            <form id="get_free_coin" enctype="multipart/form-data">
                                <input type="hidden" name="_token" value="{{ csrf_token() }}">
                                <table class="table table-bordered table-striped text-center">
                                    <thead>
                                        <tr style="background: #F9FAFF;">
                                            <th width="50%"> {{__('Label.Activity Name')}} </th>
                                            <th> {{__('Label.Point')}}</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>{{__('Label.Free-coin')}}</td>
                                            <td><input type="number" name="free-coin" class="form-control" min="0" value="{{$earn_point['free-coin']}}"></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <br><br>
                                <div class="border-top pt-3 text-right">
                                    <button type="button" class="btn btn-default mw-120" onclick="get_free_coin()">{{__('Label.SAVE')}}</button>
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
        function earning_setting() {
            $("#dvloader").show();
            var formData = new FormData($("#earning_setting")[0]);

            $.ajax({
                type: 'POST',
                url: '{{ route("earning_settingSave") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    get_responce_message(resp, 'earning_setting', '{{ route("earningsetting") }}');
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
        function earnpoint_setting() {
            $("#dvloader").show();
            var formData = new FormData($("#earnpoint_setting")[0]);

            $.ajax({
                type: 'POST',
                url: '{{ route("setearningpoint") }}',
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
        function spinwheelpoint() {
            $("#dvloader").show();
            var formData = new FormData($("#spinwheelpoint")[0]);

            $.ajax({
                type: 'POST',
                url: '{{ route("spinwheelpoint") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    $("html, body").animate({
                        scrollTop: 0
                    }, "swing");
                    get_responce_message(resp);
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
        function daily_login() {
            $("#dvloader").show();
            var formData = new FormData($("#daily_login")[0]);

            $.ajax({
                type: 'POST',
                url: '{{ route("dailyloginpoint") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    $("html, body").animate({
                        scrollTop: 0
                    }, "swing");
                    get_responce_message(resp);
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
        function get_free_coin() {
            $("#dvloader").show();
            var formData = new FormData($("#get_free_coin")[0]);

            $.ajax({
                type: 'POST',
                url: '{{ route("getfreecongpoint") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    $("html, body").animate({
                        scrollTop: 0
                    }, "swing");
                    get_responce_message(resp);
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
    </script>
@endsection