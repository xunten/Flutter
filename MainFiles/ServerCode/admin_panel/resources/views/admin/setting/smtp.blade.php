@extends('layout.page-app')
@section('page_title',  __('Label.SMTP Setting'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.SMTP Setting')}}</h1>

            <div class="border-bottom row mb-3">
                <div class="col-sm-12">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            <a href="{{ route('setting') }}">{{__('Label.Setting')}}</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            SMTP Setting
                        </li>
                    </ol>
                </div>
            </div>

            <div class="card custom-border-card mt-3">
                <h5 class="card-header">Email Setting [SMTP]</h5>
                <div class="card-body">
                    <form id="smtp_setting">
                        <input type="hidden" name="_token" value="{{ csrf_token() }}">
                        <input type="hidden" name="id" value="@if($smtp){{$smtp->id}}@endif">
                        <div class="form-row">
                            <div class="form-group  col-md-3">
                                <label>{{__('Label.IS SMTP Active')}}</label>
                                <select name="status" class="form-control">
                                    <option value="">Select Status</option>
                                    <option value="0" @if($smtp){{ $smtp->status == 0  ? 'selected' : ''}}@endif>{{__('Label.No')}}</option>
                                    <option value="1" @if($smtp){{ $smtp->status == 1  ? 'selected' : ''}}@endif>{{__('Label.Yes')}}</option>
                                </select>
                            </div>
                            <div class="form-group col-md-3">
                                <label>{{__('Label.Host')}}</label>
                                <input type="text" name="host" class="form-control" value="@if($smtp){{$smtp->host}}@endif" placeholder="Enter Host">
                            </div>
                            <div class="form-group col-md-3">
                                <label>{{__('Label.Port')}}</label>
                                <input type="text" name="port" class="form-control" value="@if($smtp){{$smtp->port}}@endif" placeholder="Enter Port">
                            </div>
                            <div class="form-group col-md-3">
                                <label>{{__('Label.Protocol')}}</label>
                                <input type="text" name="protocol" class="form-control" value="@if($smtp){{$smtp->protocol}}@endif" placeholder="Enter Protocol">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-3">
                                <label>{{__('Label.User name')}}</label>
                                <input type="text" name="user" class="form-control" value="@if($smtp){{$smtp->user}}@endif" placeholder="Enter User Name">
                            </div>
                            <div class="form-group col-md-3">
                                <label>{{__('Label.Password')}}</label>
                                <input type="password" name="pass" class="form-control" value="@if($smtp){{$smtp->pass}}@endif" placeholder="Enter Password">
                                <label class="mt-1 text-gray">Search for better result <a href="https://support.google.com/mail/answer/185833?hl=en" target="_blank" class="btn-link">Click Here</a></label>
                            </div>
                            <div class="form-group col-md-3">
                                <label>{{__('Label.From name')}}</label>
                                <input type="text" name="from_name" class="form-control" value="@if($smtp){{$smtp->from_name}}@endif" placeholder="Enter From Name">
                            </div>
                            <div class="form-group col-md-3">
                                <label>{{__('Label.From Email')}}</label>
                                <input type="text" name="from_email" class="form-control" value="@if($smtp){{$smtp->from_email}}@endif" placeholder="Enter From Email">
                            </div>
                        </div>
                        <div class="border-top pt-3 text-right">
                            <button type="button" class="btn btn-default mw-120" onclick="smtp_setting()">{{__('Label.SAVE')}}</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('pagescript')
    <script>
        function smtp_setting() {
            var formData = new FormData($("#smtp_setting")[0]);
            $.ajax({
                type: 'POST',
                url: '{{ route("smtp.save") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    get_responce_message(resp, 'smtp_setting', '{{ route("setting") }}');
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
    </script>
@endsection
