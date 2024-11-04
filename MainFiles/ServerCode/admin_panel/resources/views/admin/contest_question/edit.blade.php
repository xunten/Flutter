@extends('layout.page-app')
@section('page_title', __('Label.Edit Contest Question'))

@section('content')
  	@include('layout.sidebar')

	<div class="right-content">
		@include('layout.header')

    	<div class="body-content">
      		<!-- mobile title -->
      		<h1 class="page-title-sm">{{__('Label.Edit Contest Question')}}</h1>

 			<div class="border-bottom row mb-3">
 				<div class="col-sm-10">
 					<ol class="breadcrumb">
 						<li class="breadcrumb-item">
 							<a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a>
 						</li>
 						<li class="breadcrumb-item">
 							<a href="{{ route('contestquestion.index') }}">{{__('Label.Contest Question')}}</a>
 						</li>
 						<li class="breadcrumb-item active" aria-current="page">
 							{{__('Label.Edit Contest Question')}}
 						</li>
 					</ol>
 				</div>
 				<div class="col-sm-2 d-flex align-items-center justify-content-end">
 					<a href="{{ route('contestquestion.index') }}" class="btn btn-default mw-120" style="margin-top:-14px">{{__('Label.Contest Question')}}</a>
 				</div>
 			</div>

 			<div class="card custom-border-card mt-3">
 				<form enctype="multipart/form-data" id="save_edit_contest_question">
					<input type="hidden" name="id" value="@if($result){{$result->id}}@endif">
				 	<div class="form-row">
						<div class="col-md-9">
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.CATEGORY')}}</label>
										<select class="form-control" name="category_id">
											<option value="">{{__('Select Category')}}</option>
											@foreach ($category as $key => $value)
											<option value="{{ $value->id }}" {{ $result->category_id == $value->id  ? 'selected' : ''}} >
												{{ $value->name}}
											</option>
											@endforeach  
										</select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.CONTEST')}}</label>
										<select class="form-control" name="contest_id">
											<option value="">{{__('Select Contest')}}</option>
											@foreach ($contest as $key => $value)
											<option value="{{ $value->id}}" {{ $result->contest_id == $value->id  ? 'selected' : ''}}> 
												{{ $value->name }} 
											</option>
											@endforeach  
										</select>
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-12">
									<div class="form-group">
										<label>{{__('Label.QUESTION')}}</label>
										<textarea class="form-control" rows="1" placeholder="Enter the Question" name="question">{{$result->question}}</textarea>
									</div>
								</div>
							</div> 
							<div class="form-row mt-3">
								<div class="col-md-6">
									<div class="form-group">
										<label>{{__('Label.QUESTION TYPE')}}</label>
										<span class="border col-md-3 p-2 m-4">
											<input type="radio" value="1" {{ ($result->question_type) == '1' ? 'checked' : '' }} id="question_type" name="question_type" class="question_type">
										   <label for="question_type">{{__('Label.Options')}}</label>
										</span>
										<span class="border col-md-3 p-2">
											<input type="radio" value="2" {{ ($result->question_type) == '2' ? 'checked' : '' }}  name="question_type" id="question_type1" class="question_type">
										   <label for="question_type">{{__('Label.True/False')}}</label>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group row">
								<div class="col-md-2"></div>
								<div class="col-md-5">
									<label class="form-check-input">{{__('Label.A')}}</label>
								   <input type="text" value="{{$result->option_a}}" name="option_a" class="form-control" placeholder="Enter Option A">
								</div>
								<div class="col-md-5">
									<label class="form-check-input">{{__('Label.B')}}</label>
								   <input type="text" value="{{$result->option_b}}" name="option_b" class="form-control" placeholder="Enter Option B">
								</div>
							</div>
							<div class="form-group row option_class">
								<div class="col-md-2"></div>
								<div class="col-md-5">
									<label class="form-check-input">{{__('Label.C')}}</label>
								   <input type="text" value="{{$result->option_c}}" name="option_c" class="form-control" placeholder="Enter Option C">
								</div>
								<div class="col-md-5">
									<label class="form-check-input">{{__('Label.D')}}</label>
								   <input type="text" value="{{$result->option_d}}" name="option_d" class="form-control" placeholder="Enter Option D">
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.ANSWER')}}</label>
										<select class="form-control" name="answer">
											<option>{{__('Label.Select Answer')}}</option>
											<option value="1" {{ ($result->answer) == '1' ? 'selected' : '' }} > {{__('Label.A')}} </option>
											<option  value="2" {{ ($result->answer) == '2' ? 'selected' : '' }} >{{__('Label.B')}}</option>
											<option value="3" {{ ($result->answer) == '3' ? 'selected' : '' }} class="option_class"> {{__('Label.C')}} </option>
											<option value="4" {{ ($result->answer) == '4' ? 'selected' : '' }} class="option_class"> {{__('Label.D')}} </option>
										</select>
									</div>
								</div>
								<div class="col-md-8">
									<div class="form-group">
										<label>{{__('Label.NOTE')}} (This will be showing with review section only)</label>
										<textarea class="form-control" rows="1" name="note" placeholder="Enter Note...">{{$result->note}}</textarea>
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
										<img src="{{$result['image']}}" alt="no_img.png" id="imagePreview">
									</div>
								</div>
								<input type="hidden" name="old_image" value="@if($result){{$result->image}}@endif">
								<label class="mt-3 ml-5 text-gray">Maximum size 2MB.</label>
							</div>
						</div>
					</div>
 					<div class="border-top pt-3 text-right">
 						<button type="button" class="btn btn-default mw-120" onclick="save_edit_contest_question()">{{__('Label.UPDATE')}}</button>
 						<a href="{{route('contestquestion.index')}}" class="btn btn-cancel mw-120 ml-2">{{__('Label.CANCEL')}}</a>
						<input type="hidden" name="_method" value="PATCH">
 					</div>
 				</form>
 			</div>
 		</div>
 	</div>
@endsection

@section('pagescript')
	<script>
		function save_edit_contest_question(){
			$("#dvloader").show();
			var formData = new FormData($("#save_edit_contest_question")[0]);
			$.ajax({
				type:'POST',
				url:'{{ route("contestquestion.update", [$result->id]) }}',
				data:formData,
				cache:false,
				contentType: false,
				processData: false,
				success:function(resp){
					$("#dvloader").hide();
					get_responce_message(resp, 'save_edit_contest_question', '{{ route("contestquestion.index") }}');
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$("#dvloader").hide();
					toastr.error(errorThrown.msg,'failed');         
				}
			});
		}

		$(document).ready(function() {
			var myVal = <?php echo $result->question_type; ?>;
			if (myVal == 2) {
				$('.option_class').hide();
			} else {
				$('.option_class').show();
			}
		});
		$('.question_type').on('click', function() {

			var question_type = $('input[name=question_type]:checked').val()
			if (question_type == 1) {
				$('.option_class').show();
			} else {
				$('.option_class').hide();
			}
		})
    </script>
@endsection