@extends('layout.page-app')
@section('page_title',  __('Label.Notification Setting'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.Notification Setting')}}</h1>

 			<div class="border-bottom row">
 				<div class="col-sm-12">
 					<ol class="breadcrumb">
 						<li class="breadcrumb-item"><a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a></li>
 						<li class="breadcrumb-item active" aria-current="page">{{__('Label.Notification Setting')}}</li>
 					</ol>
 				</div>
 			</div>

 			<div class="card custom-border-card mt-3">
 				<form id="save_notificationsetting">
 					<div class="form-row">
 						<div class="col-md-4">
 							<div class="form-group">
 								<label>{{__('Label.ONESIGNAL APP ID')}}</label>
 								<input name="onesignal_apid" type="text" class="form-control" value="@if($result){{$result['onesignal_apid']}}@endif" placeholder="Enter Onesignal App ID" autofocus>
 							</div>
 						</div>
 						<div class="col-md-4">
 							<div class="form-group">
 								<label>{{__('Label.ONESIGNAL REST KEY')}}</label>
 								<input name="onesignal_rest_key" type="text" class="form-control" value="@if($result){{$result['onesignal_rest_key']}}@endif" placeholder="Enter Onesignal Rest Key">
 							</div>
 						</div>
 					</div>
 					<div class="border-top pt-3 text-right">
 						<button type="button" class="btn btn-default mw-120" onclick="save_notificationsetting()">{{__('Label.SAVE')}}</button>
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
		function save_notificationsetting(){
			$("#dvloader").show();
			var formData = new FormData($("#save_notificationsetting")[0]);
			$.ajax({
				type:'POST',
				url:'{{ route("notification_settingsave") }}',
				data:formData,
				cache:false,
				contentType: false,
				processData: false,
				success:function(resp){
					$("#dvloader").hide();
					get_responce_message(resp, 'save_notificationsetting', '{{ route("notification.index") }}');
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					toastr.error(errorThrown.msg,'failed');         
				}
			});
		}
	</script>
@endsection