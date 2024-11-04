@extends('layout.page-app')
@section('page_title',  __('Label.Add_Package'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.Add Subscription')}}</h1>

			<div class="border-bottom row mb-3">
				<div class="col-sm-10">
					<ol class="breadcrumb">
						<li class="breadcrumb-item">
							<a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a>
						</li>
						<li class="breadcrumb-item">
							<a href="{{ route('package.index') }}">{{__('Label.Packages')}}</a>
						</li>
						<li class="breadcrumb-item active" aria-current="page">
							{{__('Label.Add_Package')}}
						</li>
					</ol>
				</div>
				<div class="col-sm-2 d-flex align-items-center justify-content-end">
					<a href="{{ route('package.index') }}" class="btn btn-default mw-120" style="margin-top:-14px">{{__('Label.Packages')}}</a>
				</div>
			</div>

			<div class="card custom-border-card mt-3">
				<form enctype="multipart/form-data" id="save_subscription">
					<input type="hidden" name="id" value="">
					<div class="form-row">
						<div class="col-md-8">
							<div class="form-row">
								<div class="col-md-6">
									<div class="form-group">
										<label>{{__('Label.NAME')}}</label>
										<input name="name" type="text" class="form-control" placeholder="{{__('Label.Enter name')}}" autofocus>
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<label>{{__('Label.Point')}}</label>
										<input name="point" type="number" class="form-control" placeholder="Enter Point" min="0">
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-6">
									<div class="form-group">
										<label>{{__('Label.PRICE')}}</label>
										<input name="price" type="number" class="form-control" placeholder="{{__('Label.Enter Price')}}" min="0">
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<label>Currency</label>
										<input name="currency_type" type="text" class="form-control" readonly  value="{{ currency_code() }}">
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-6">
									<div class="form-group">
										<label>Android Product Package</label>
										<input name="android_product_package" type="text" class="form-control" placeholder="Enter Android Product Package">
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<label>IOS Product Package</label>
										<input name="ios_product_package" type="text" class="form-control" placeholder="Enter IOS Product Package">
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group ml-5">
								<label class="ml-5">{{__('Label.IMAGE')}}</label>
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
						<button type="button" class="btn btn-default mw-120" onclick="save_subscription()">{{__('Label.SAVE')}}</button>
						<a href="{{route('package.index')}}" class="btn btn-cancel mw-120 ml-2">{{__('Label.CANCEL')}}</a>
						<input type="hidden" name="_token" value="{{ csrf_token() }}">
					</div>
				</form>
			</div>
		</div>
	</div>
@endsection

@section('pagescript')
	<script>
		function save_subscription(){
			$("#dvloader").show();
			var formData = new FormData($("#save_subscription")[0]);
			$.ajax({
				type:'POST',
				url:'{{ route("package.store") }}',
				data:formData,
				cache:false,
				contentType: false,
				processData: false,
				success:function(resp){
					$("#dvloader").hide();
					get_responce_message(resp, 'save_subscription', '{{ route("package.index") }}');
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$("#dvloader").hide();
					toastr.error(errorThrown.msg,'failed');         
				}
			});
		}
	</script>
@endsection