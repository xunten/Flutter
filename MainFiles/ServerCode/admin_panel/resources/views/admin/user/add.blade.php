@extends('layout.page-app')
@section('page_title',  __('Label.Add User'))

@section('content')
	@include('layout.sidebar')

	<div class="right-content">
		@include('layout.header')

		<div class="body-content">
			<!-- mobile title -->
			<h1 class="page-title-sm">{{__('Label.Add User')}}</h1>

			<div class="border-bottom row mb-3">
				<div class="col-sm-10">
					<ol class="breadcrumb">
						<li class="breadcrumb-item">
							<a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a>
						</li>
						<li class="breadcrumb-item">
							<a href="{{ route('user.index') }}">{{__('Label.Users')}}</a>
						</li>
						<li class="breadcrumb-item active" aria-current="page">
							{{__('Label.Add User')}}
						</li>
					</ol>
				</div>
				<div class="col-sm-2 d-flex align-items-center justify-content-end">
					<a href="{{ route('user.index') }}" class="btn btn-default mw-120" style="margin-top:-14px">{{__('Label.Users List')}}</a>
				</div>
			</div>

			<div class="card custom-border-card mt-3">
				<form id="save_user" enctype="multipart/form-data">
					<input type="hidden" name="id" value="">
					<div class="form-row">
						<div class="col-md-8">
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.Full_Name')}}</label>
										<input name="fullname" type="text" class="form-control" placeholder="Enter Full Name" autofocus>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.MOBILE NUMBER')}}</label>
										<input name="mobile_number" type="text" class="form-control" placeholder="Enter Mobile Number">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.INSTAGRAM URL')}}</label>
										<input name="instagram_url" type="text" class="form-control" placeholder="Enter Instagram URL">
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.EMAIL')}}</label>
										<input name="email" type="email" class="form-control" placeholder="Enter Email">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.PASSWORD')}}</label>
										<input name="password" type="password" class="form-control" placeholder="Enter Password">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.FACEBOOK URL')}}</label>
										<input name="facebook_url" type="text" class="form-control" placeholder="Enter Facebook URL">
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.TWITTER URL')}}</label>
										<input name="twitter_url" type="text" class="form-control" placeholder="Enter Twitter URL">
									</div>
								</div>
								<div class="col-md-8">
									<div class="form-group">
										<label>{{__('Label.BIO DATA')}}</label>
										<input name="biodata" type="text" class="form-control" placeholder="Enter Bio Data">
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group ml-5">
								<label class="ml-5">{{__('Label.IMAGE')}}</label>
								<div class="avatar-upload ml-5">
									<div class="avatar-edit">
										<input type='file' name="profile_img" id="imageUpload" accept=".png, .jpg, .jpeg" />
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
						<button type="button" class="btn btn-default mw-120" onclick="save_user()">{{__('Label.SAVE')}}</button>
						<a href="{{route('user.index')}}" class="btn btn-cancel mw-120 ml-2">{{__('Label.CANCEL')}}</a>
						<input type="hidden" name="_token" value="{{ csrf_token() }}">
					</div>
				</form>
			</div>
		</div>
	</div>
@endsection

@section('pagescript')
	<script>
		function save_user(){
			$("#dvloader").show();
			var formData = new FormData($("#save_user")[0]);
			$.ajax({
				type:'POST',
				url:'{{ route("user.store") }}',
				data:formData,
				cache:false,
				contentType: false,
				processData: false,
				success:function(resp){
					$("#dvloader").hide();
					get_responce_message(resp, 'save_user', '{{ route("user.index") }}');
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$("#dvloader").hide();
					toastr.error(errorThrown.msg,'failed');         
				}
			});
		}
	</script>
@endsection