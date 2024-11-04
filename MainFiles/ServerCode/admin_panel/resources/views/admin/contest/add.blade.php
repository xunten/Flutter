@extends('layout.page-app')
@section('page_title',  __('Label.Add Contest'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.Add Contest')}}</h1>

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
							{{__('Label.Add Contest')}}
						</li>
					</ol>
				</div>
				<div class="col-sm-2 d-flex align-items-center justify-content-end">
					<a href="{{ route('contests.index') }}" class="btn btn-default mw-120" style="margin-top:-14px">{{__('Label.Contest')}}</a>
				</div>
			</div>

			<div class="card custom-border-card mt-3">
				<form enctype="multipart/form-data" id="save_contest">
					<input type="hidden" name="id" value="">
					<div class="form-row">
						<div class="col-md-9">
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label for="name">{{__('Label.NAME')}}</label>
										<input name="name" type="text" class="form-control" placeholder="Enter Contest Name" autofocus>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.LEVEL')}}</label>
										<select class="form-control" name="level_id">
											<option value="">{{__('Label.Select Level')}}</option>
											@foreach ($result as $key => $value)
											<option value="{{ $value->id}}"> 
												{{ $value->name }} 
											</option>
											@endforeach  
										</select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.ENTRY FEE')}}</label>
										<input name="price" type="number" class="form-control" value="0" min="0">
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.START DATE')}}</label>
										<input name="start_date" type="datetime-local" class="form-control">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.END DATE')}}</label>
										<input name="end_date" type="datetime-local" class="form-control">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.NO OF USER')}}</label>
										<input name="no_of_user" type="number" class="form-control" value="0" min="0">
									</div>
								</div>
							</div>
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.NO OF USER PRIZE')}}</label>
										<input name="no_of_user_prize" type="number" class="form-control" value="0" min="0">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.NO OF RANK')}}</label>
										<input name="no_of_rank" type="number" class="form-control" value="1" min="0">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>{{__('Label.TOTAL PRIZE')}}</label>
										<input name="total_prize" type="number" class="form-control" value="0" min="0">
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
										<img src="{{asset('assets/imgs/upload_img.png')}}" alt="upload_img.png" id="imagePreview">
									</div>
								</div>
								<label class="mt-3 ml-5 text-gray">Maximum size 2MB.</label>
							</div>
						</div>
					</div>
					<div class="border-top pt-3 text-right">
						<button type="button" class="btn btn-default mw-120" onclick="save_contest()">{{__('Label.SAVE')}}</button>
						<a href="{{route('contests.index')}}" class="btn btn-cancel mw-120 ml-2">{{__('Label.CANCEL')}}</a>
						<input type="hidden" name="_token" value="{{ csrf_token() }}">
					</div>
				</form>
			</div>
		</div>
	</div>
@endsection

@section('pagescript')
	<script>
		function save_contest(){
			$("#dvloader").show();
			var formData = new FormData($("#save_contest")[0]);
			$.ajax({
				type:'POST',
				url:'{{ route("contests.store") }}',
				data:formData,
				cache:false,
				contentType: false,
				processData: false,
				success:function(resp){
					$("#dvloader").hide();
					get_responce_message(resp, 'save_contest', '{{ route("contests.index") }}');
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$("#dvloader").hide();
					toastr.error(errorThrown.msg,'failed');         
				}
			});
		}
	</script>
@endsection
