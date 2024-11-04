@extends('layout.page-app')
@section('page_title', __('Label.Edit Contest'))

@section('content')
	@include('layout.sidebar')

	<div class="right-content">
		@include('layout.header')

		<div class="body-content">
			<!-- mobile title -->
			<h1 class="page-title-sm">{{__('Label.Edit Contest')}}</h1>

			<div class="border-bottom row mb-3">
				<div class="col-sm-10">
					<ol class="breadcrumb">
						<li class="breadcrumb-item">
							<a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a>
						</li>
						<li class="breadcrumb-item">
							<a href="{{ route('contests.index') }}">{{__('Label.Contest')}}</a>
						</li>
						<li class="breadcrumb-item active" aria-current="page">
							{{__('Label.Edit Contest')}}
						</li>
					</ol>
				</div>
				<div class="col-sm-2 d-flex align-items-center justify-content-end">
					<a href="{{ route('contests.index') }}" class="btn btn-default mw-120" style="margin-top:-14px">{{__('Label.Contest')}}</a>
				</div>
			</div>

			<div class="card custom-border-card mt-3">
				<form enctype="multipart/form-data" id="save_edit_contest">
					<input type="hidden" name="id" value="@if($result){{$result->id}}@endif">
					<div class="form-row">
						<div class="col-md-9">
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.NAME')}}</label>
										<input name="name" type="text" class="form-control" value="{{$result->name}}" placeholder="Enter Contest Name" autofocus> 
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.LEVEL')}}</label>
										<select class="form-control" name="level_id">
											<option value="">{{__('Label.Select Level')}}</option>
											@foreach ($level as $key => $value)
											<option value="{{ $value->id}}" {{ $result->level_id == $value->id  ? 'selected' : ''}}> 
												{{ $value->name }} 
											</option>
											@endforeach  
										</select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.ENTRY FEE')}}</label>
										<input name="price" type="number" class="form-control" value="{{$result->price}}" min="0">
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.START DATE')}}</label>
										<input name="start_date" type="datetime-local" class="form-control" value="{{$result->start_date}}">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.END DATE')}}</label>
										<input name="end_date" type="datetime-local" class="form-control" value="{{$result->end_date}}">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.NO OF USER')}}</label>
										<input name="no_of_user" type="number" class="form-control" value="{{$result->no_of_user}}" min="0">
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.NO OF USER PRIZE')}}</label>
										<input name="no_of_user_prize" type="number" class="form-control" value="{{$result->no_of_user_prize}}" min="0">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.NO OF RANK')}}</label>
										<input name="no_of_rank" type="number" class="form-control" value="{{$result->no_of_rank}}" min="0">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.TOTAL PRIZE')}}</label>
										<input name="total_prize" type="number" class="form-control" value="{{$result->total_prize}}" min="0">
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-3">
							<div class="form-group ml-5">
								<label class="ml-5">{{__('Label.IMAGE')}}</label>
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
						<button type="button" class="btn btn-default mw-120" onclick="save_edit_contest()">{{__('Label.UPDATE')}}</button>
						<a href="{{route('contests.index')}}" class="btn btn-cancel mw-120 ml-2">{{__('Label.CANCEL')}}</a>
						<input type="hidden" name="_method" value="PATCH">
					</div>
				</form>
			</div>
		</div>
	</div>
@endsection

@section('pagescript')
	<script>
		function save_edit_contest(){
			$("#dvloader").show();
			var formData = new FormData($("#save_edit_contest")[0]);
			$.ajax({
				type:'POST',
				url:'{{ route("contests.update", [$result->id]) }}',
				data:formData,
				cache:false,
				contentType: false,
				processData: false,
				success:function(resp){
					$("#dvloader").hide();
					get_responce_message(resp, 'save_edit_contest', '{{ route("contests.index") }}');
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$("#dvloader").hide();
					toastr.error(errorThrown.msg,'failed');         
				}
			});
		}
	</script>
@endsection
