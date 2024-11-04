@extends('layout.page-app')
@section('page_title', __('Label.add_audio_question'))

@section('content')
	@include('layout.sidebar')

	<div class="right-content">
		@include('layout.header')

		<div class="body-content">
			<!-- mobile title -->
			<h1 class="page-title-sm">{{__('Label.add_audio_question')}}</h1>

			<div class="border-bottom row mb-3">
				<div class="col-sm-10">
					<ol class="breadcrumb">
						<li class="breadcrumb-item">
							<a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a>
						</li>
						<li class="breadcrumb-item">
							<a href="{{ route('audioquestion.index') }}">{{__('Label.add_audio_question')}}</a>
						</li>
						<li class="breadcrumb-item active" aria-current="page">
							{{__('Label.Add Question')}}
						</li>
					</ol>
				</div>
				<div class="col-sm-2 d-flex align-items-center justify-content-end">
					<a href="{{ route('audioquestion.index') }}" class="btn btn-default mw-120" style="margin-top:-14px">{{__('Label.audio_question')}}</a>
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
								<div class="form-group col-md-4">
									<label>{{__('Label.audio_upload_type')}}</label>
									<select name="audio_type" id="audio_type" class="form-control">
										<option selected="selected" value="server_video">{{__('Label.server_video')}}</option>
										<option value="external_url">{{__('Label.external_url')}}</option>
									</select>
								</div>
								<div class="form-group col-md-8 video_box">
									<label>{{__('Label.audio_file')}}</label>
									<input name="audio" type="file" class="form-control import-file" accept=".mp3">
									<label class="mt-1 text-gray">Note: Audio File size must be less than 5MB. && Audio type supported (mp3)</label>
								</div>
								<div class="form-group col-md-8 url_box">
									<label>{{__('Label.url')}}</label>
									<input name="audio_url" type="url" class="form-control" placeholder="Enter Audio URL">
								</div>
							</div>
							<div class="form-row mt-3">
								<div class="col-md-6">
									<div class="form-group">
										<label>{{__('Label.QUESTION TYPE')}}</label>
										<span class="border col-md-3 p-2 m-4">
											<input type="radio" value="1" checked="checked" id="question_type" name="question_type" class="question_type">
											<label for="question_type">{{__('Label.Options')}}</label>
										</span>
										<span class="border col-md-3 p-2">
											<input type="radio" value="2" name="question_type" class="question_type">
											<label for="question_type">{{__('Label.True/False')}}</label>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group row">
								<div class="col-md-2"></div>
								<div class="col-md-5">
									<label class="form-check-input">{{__('Label.A')}}</label>
									<input type="text" name="option_a" class="form-control" placeholder="Enter Option A">
								</div>
								<div class="col-md-5">
									<label class="form-check-input">{{__('Label.B')}}</label>
									<input type="text" name="option_b" class="form-control" placeholder="Enter Option B">
								</div>
							</div>
							<div class="form-group row option_class">
								<div class="col-md-2"></div>
								<div class="col-md-5">
									<label class="form-check-input">{{__('Label.C')}}</label>
									<input type="text" name="option_c" class="form-control" placeholder="Enter Option c">
								</div>
								<div class="col-md-5">
									<label class="form-check-input">{{__('Label.D')}}</label>
									<input type="text" name="option_d" class="form-control" placeholder="Enter Option D">
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.ANSWER')}}</label>
										<select class="form-control" name="answer">
											<option value="">{{__('Label.Select Answer')}}</option>
											<option value="1"> {{__('Label.A')}} </option>
											<option value="2"> {{__('Label.B')}} </option>
											<option value="3" class="option_class"> {{__('Label.C')}} </option>
											<option value="4" class="option_class"> {{__('Label.D')}} </option>
										</select>
									</div>
								</div>
								<div class="col-md-8">
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
						<a href="{{route('audioquestion.index')}}" class="btn btn-cancel mw-120 ml-2">{{__('Label.CANCEL')}}</a>
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
				url:'{{ route("audioquestion.store") }}',
				data: formData,
				cache: false,
				contentType: false,
				processData: false,
				success: function(resp) {
					$("#dvloader").hide();
					get_responce_message(resp, 'save_question', '{{ route("audioquestion.index") }}');
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$("#dvloader").hide();
					toastr.error(errorThrown.msg, 'failed');
				}
			});
		}
		$('.question_type').on('click', function() {
			var question_type = $('input[name=question_type]:checked').val()
			if (question_type == 1) {
				$('.option_class').show();
			} else {
				$('.option_class').hide();
			}
		})
		$(document).ready(function() {
			$(".url_box").hide();
			$('#audio_type').change(function() {
				var optionValue = $(this).val();

				if (optionValue == "server_video") {
					$(".video_box").show();
					$(".url_box").hide();
				} else {
					$(".url_box").show();
					$(".video_box").hide();
				}
			});
		});
	</script>
@endsection