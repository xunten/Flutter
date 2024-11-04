@extends('layout.page-app')
@section('page_title', __('Label.Add Notification'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.Add Notification')}}</h1>

            <div class="border-bottom row mb-3">
                <div class="col-sm-10">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="{{ route('notification.index') }}">{{__('Label.Notification')}}</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            {{__('Label.Add Notification')}}
                        </li>
                    </ol>
                </div>
                <div class="col-sm-2 d-flex align-items-center justify-content-end">
                    <a href="{{ route('notification.index') }}" class="btn btn-default mw-120" style="margin-top:-14px">{{__('Label.Notification List')}}</a>
                </div>
            </div>

            <div class="card custom-border-card mt-3">
                <form enctype="multipart/form-data" id="save_notification_send">
                    <input type="hidden" name="id" value="">
                    <div class="form-row">
                        <div class="col-md-8">
                            <div class="form-row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>{{__('Label.TITLE')}}</label>
                                        <input name="title" type="text" class="form-control" placeholder="{{__('Label.Enter Title')}}" autofocus>
                                    </div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>{{__('Label.MESSAGE')}}</label>
                                        <textarea class="form-control" rows="3" name="description" placeholder="start Write Here..."></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
							<div class="form-group ml-5">
								<label class="ml-5">{{__('Label.IMAGE')}} <label class="text-gray">(Optional)</label></label>
								<div class="avatar-upload ml-5">
									<div class="avatar-edit">
										<input type='file' name="image" id="imageUpload" accept=".png, .jpg, .jpeg" />
										<label for="imageUpload" title="Select File"></label>
									</div>
									<div class="avatar-preview">
										<img src="{{asset('assets/imgs/upload_img.png')}}" alt="upload_img.png" id="imagePreview">
									</div>
								</div>
								<label class="mt-3 ml-5 text-gray">Maximum size 2MB.</label>
							</div>
						</div>
                    </div>
                    <div class="border-top pt-3 text-right">
                        <button type="button" class="btn btn-default mw-120" onclick="save_notification_send()">{{__('Label.SAVE')}}</button>
                        <a href="{{route('notification.index')}}" class="btn btn-cancel mw-120 ml-2">{{__('Label.CANCEL')}}</a>
                        <input type="hidden" name="_token" value="{{ csrf_token() }}">
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection

@section('pagescript')
    <script>
        function save_notification_send() {
            $("#dvloader").show();
            var formData = new FormData($("#save_notification_send")[0]);
            $.ajax({
                type: 'POST',
                url:'{{ route("notification.store") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    get_responce_message(resp, 'save_notification_send', '{{ route("notification.index") }}');
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
    </script>
@endsection