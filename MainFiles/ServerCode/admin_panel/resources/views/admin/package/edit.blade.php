@extends('layout.page-app')
@section('page_title', __('Label.Edit_Package'))

@section('content')
	@include('layout.sidebar')

	<div class="right-content">
		@include('layout.header')

		<div class="body-content">
			<!-- mobile title -->
			<h1 class="page-title-sm">{{__('Label.Edit Subscription')}}</h1>

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
							{{__('Label.Edit_Package')}}
						</li>
					</ol>
				</div>
				<div class="col-sm-2 d-flex align-items-center justify-content-end">
					<a href="{{ route('package.index') }}"class="btn btn-default mw-120"style="margin-top:-14px">{{__('Label.Packages')}}</a>
				</div>
			</div>

			<div class="card custom-border-card mt-3">
				<form enctype="multipart/form-data" id="save_edit_subscription">
					<input type="hidden" name="id" value="@if($result){{$result->id}}@endif">
					<div class="form-row">
						<div class="col-md-8">
							<div class="form-row">
								<div class="col-md-6">
									<div class="form-group">
										<label>{{__('Label.NAME')}}</label>
										<input name="name" type="text" class="form-control" placeholder="Enter name" value="{{$result->name}}" autofocus>
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<label>{{__('Label.Point')}}</label>
										<input name="point" type="number" class="form-control" placeholder="Enter Point" value="{{$result->point}}" min="0">
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-6">
									<div class="form-group">
										<label>{{__('Label.PRICE')}}</label>
										<input name="price" type="number" class="form-control" placeholder="Enter Price" value="{{$result->price}}">
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<label>{{__('Label.TYPE')}}</label>
										<input name="currency_type" type="text" class="form-control" readonly value="{{ currency_code() }}" >
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-6">
									<div class="form-group">
										<label>Android Product Package</label>
										<input name="android_product_package" type="text" class="form-control" placeholder="Enter Android Product Package"  value="@if($result){{$result->android_product_package}}@endif">
									</div>
								</div>
								<div class="col-md-6">
									<div class="form-group">
										<label>IOS Product Package</label>
										<input name="ios_product_package" type="text" class="form-control" placeholder="Enter IOS Product Package" value="@if($result){{$result->ios_product_package}}@endif">
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group ml-5">
								<label class="ml-5">Thumbnail image</label>
								<div class="avatar-upload ml-5">
									<div class="avatar-edit">
										<input type='file' name="image" id="imageUpload" accept=".png, .jpg, .jpeg" />
										<label for="imageUpload" title="Select File"></label>
									</div>
									<div class="avatar-preview">
										<img src="{{$result['image']}}" alt="no_img.png" id="imagePreview">
									</div>
								</div>
								<input type="hidden" name="old_image" value="@if($result){{$result->image}}@endif">
								<label class="mt-3 ml-5 text-gray">Maximum size 2MB.</label>
							</div>
						</div>
					</div>
					<div class="border-top pt-3 text-right">
						<button type="button" class="btn btn-default mw-120" onclick="save_edit_subscription()">{{__('Label.UPDATE')}}</button>
						<a href="{{route('package.index')}}" class="btn btn-cancel mw-120 ml-2">{{__('Label.CANCEL')}}</a>
						<input type="hidden" name="_method" value="PATCH">
					</div>
				</form>
			</div>
		</div>
	</div>
@endsection

@section('pagescript')
    <script>
    	function save_edit_subscription(){
			$("#dvloader").show();
    		var formData = new FormData($("#save_edit_subscription")[0]);
    		$.ajax({
    			type:'POST',
				url:'{{ route("package.update", [$result->id]) }}',
    			data:formData,
    			cache:false,
    			contentType: false,
    			processData: false,
    			success:function(resp){
				$("#dvloader").hide();
                    get_responce_message(resp, 'save_edit_subscription', '{{ route("package.index") }}');
    			},
    			error: function(XMLHttpRequest, textStatus, errorThrown) {
    				$("#dvloader").hide();
    				toastr.error(errorThrown.msg,'failed');         
    			}
    		});
    	}
    </script>
@endsection