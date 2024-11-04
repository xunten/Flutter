@extends('layout.page-app')
@section('page_title', __('Label.add_true/false_question'))

@section('content')
	@include('layout.sidebar')

	<div class="right-content">
		@include('layout.header')

		<div class="body-content">
			<!-- mobile title -->
			<h1 class="page-title-sm">{{__('Label.add_true/false_question')}}</h1>

			<div class="border-bottom row mb-3">
				<div class="col-sm-10">
					<ol class="breadcrumb">
						<li class="breadcrumb-item">
							<a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a>
						</li>
						<li class="breadcrumb-item">
							<a href="{{ route('truefalsequestion.index') }}">{{__('Label.true_false_question')}}</a>
						</li>
						<li class="breadcrumb-item active" aria-current="page">
							{{__('Label.add_true/false_question')}}
						</li>
					</ol>
				</div>
				<div class="col-sm-2 d-flex align-items-center justify-content-end">
					<a href="{{ route('truefalsequestion.index') }}" class="btn btn-default mw-120" style="margin-top:-14px">{{__('Label.true_false_question')}}</a>
				</div>
			</div>

			<div class="card custom-border-card mt-3">
				<form enctype="multipart/form-data" id="save_question">
					<input type="hidden" name="id" value="">
					<div class="form-row">
						<div class="col-md-9">
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.CATEGORY')}}</label>
										<select class="form-control" name="category_id">
											<option value="">{{__('Label.Select Category')}}</option>
											@foreach ($category as $key => $value)
											<option value="{{ $value->id}}">
												{{ $value->name }}
											</option>
											@endforeach
										</select>
									</div>
								</div>
								<div class="col-md-8">
									<div class="form-group">
										<label>{{__('Label.QUESTION')}}</label>
										<textarea class="form-control" rows="1" name="question" placeholder="Enter the Question"></textarea>
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label class="ml-3">{{__('Label.A')}}</label>
										<input type="text" name="option_a" readonly value="true" class="form-control" placeholder="Enter Option A">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label class="ml-3">{{__('Label.B')}}</label>
										<input type="text" name="option_b" readonly value="false" class="form-control" placeholder="Enter Option B">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.ANSWER')}}</label>
										<select class="form-control" name="answer">
											<option value="">{{__('Label.Select Answer')}}</option>
											<option value="1"> {{__('Label.A')}} </option>
											<option value="2"> {{__('Label.B')}} </option>
										</select>
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-12">
									<div class="form-group">
										<label>{{__('Label.NOTE')}} (This will be showing with review section only)</label>
										<textarea class="form-control" rows="1" name="note" placeholder="Enter Note"></textarea>
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-3">
							<div class="form-group ml-5">
								<label class="ml-5">Thumbnail image</label>
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
						<button type="button" class="btn btn-default mw-120" onclick="save_question()">{{__('Label.SAVE')}}</button>
						<a href="{{route('truefalsequestion.index')}}" class="btn btn-cancel mw-120 ml-2">{{__('Label.CANCEL')}}</a>
						<input type="hidden" name="_token" value="{{ csrf_token() }}">
					</div>
				</form>
			</div>
		</div>
	</div>
@endsection

@section('pagescript')
	<script>
		function save_question() {
			$("#dvloader").show();
			var formData = new FormData($("#save_question")[0]);
			$.ajax({
				type: 'POST',
				url:'{{ route("truefalsequestion.store") }}',
				data: formData,
				cache: false,
				contentType: false,
				processData: false,
				success: function(resp) {
					$("#dvloader").hide();
					get_responce_message(resp, 'save_question', '{{ route("truefalsequestion.index") }}');
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$("#dvloader").hide();
					toastr.error(errorThrown.msg, 'failed');
				}
			});
		}
	</script>
@endsection