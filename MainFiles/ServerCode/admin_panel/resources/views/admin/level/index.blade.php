@extends('layout.page-app')
@section('page_title', __('Label.Level'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.Level')}}</h1>

            <div class="border-bottom row mb-3">
                <div class="col-sm-12">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a></li>
                        <li class="breadcrumb-item active" aria-current="page">{{__('Label.Level')}}
                        </li>
                    </ol>
                </div>
            </div>

            <!-- Add Level -->
            <div class="card custom-border-card mt-3">
                <h5 class="card-header">{{__('Label.Add Level')}}</h5>
                <div class="card-body">
                    <form id="save_level" autocomplete="off" method="post" enctype="multipart/form-data">
                        <div class="form-row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.NAME')}}</label>
                                    <input name="name" type="text" class="form-control" placeholder="{{__('Label.Please Enter Level')}}" autofocus>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.LEVEL ORDER NO')}}</label>
                                    <input name="level_order" type="number" class="form-control" placeholder="{{__('Label.Enter Level Order')}}">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.SCORE')}}</label>
                                    <input name="score" type="number" class="form-control" placeholder="{{__('Label.SCORE')}}">
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.TOTAL QUESTION')}}</label>
                                    <input name="total_question" type="number" class="form-control" placeholder="{{__('Label.TOTAL QUESTION')}}">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.NEXT LEVEL QUESTION COUNT')}}</label>
                                    <input name="win_question_count" type="number" class="form-control" placeholder="{{__('Label.Win Question Count')}}">
                                </div>
                            </div>
                        </div>
                        <div class="border-top pt-3 text-right">
                            <button type="button" class="btn btn-default mw-120" onclick="save_level()">{{__('Label.SAVE')}}</button>
                            <input type="hidden" name="_token" value="{{ csrf_token() }}">
                        </div>
				    </form>
                </div>
            </div>

            <!-- Search && Table -->
            <div class="card custom-border-card mt-3">
                <div class="page-search mb-3">
                    <div class="input-group" title="Search">
                        <div class="input-group-prepend">
                            <span class="input-group-text" id="basic-addon1"><i class="fa-solid fa-magnifying-glass fa-xl light-gray"></i></span>
                        </div>
                        <input type="text" id="input_search" class="form-control" placeholder="Search Level" aria-label="Search" aria-describedby="basic-addon1">
                    </div>
                </div>

                <div class="table-responsive table">
                    <table class="table table-striped text-center table-bordered" id="datatable">
                        <thead>
                            <tr style="background: #F9FAFF;">
                                <th> {{__('Label.#')}} </th>
                                <th> {{__('Label.Name')}} </th>
                                <th> {{__('Label.Level order No')}} </th>
                                <th> {{__('Label.Score')}} </th>
                                <th> {{__('Label.Total Question')}} </th>
                                <th> {{__('Label.Next Level Question Count')}}</th>
                                <th> {{__('Label.Action')}} </th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>

            <!-- Edit Model -->
            <div class="modal fade" id="EditModel" tabindex="-1" data-backdrop="static" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">{{__('Label.Edit Level')}}</h5>
                            <button type="button" class="close text-dark" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <form id="edit_level" autocomplete="off">
                            <div class="modal-body">
                                <div class="form-row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label> {{__('Label.Name')}} </label>
                                            <input type="text" name="name" id="edit_name" class="form-control" placeholder="Enter Name">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>{{__('Label.LEVEL ORDER NO')}}</label>
                                            <input name="level_order" type="number" id="edit_level_order" class="form-control" placeholder="{{__('Label.Enter Level Order')}}">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>{{__('Label.SCORE')}}</label>
                                            <input name="score" type="number" id="edit_score" class="form-control" placeholder="{{__('Label.SCORE')}}">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>{{__('Label.TOTAL QUESTION')}}</label>
                                            <input name="total_question" type="number" id="edit_total_question" class="form-control" placeholder="{{__('Label.TOTAL QUESTION')}}">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>{{__('Label.NEXT LEVEL QUESTION COUNT')}}</label>
                                            <input name="win_question_count" type="number" id="edit_win_question_count" class="form-control" placeholder="{{__('Label.Win Question Count')}}">
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" name="id" id="edit_id">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default mw-120" onclick="update_level()">{{__('Label.UPDATE')}}</button>
                                <button type="button" class="btn btn-cancel mw-120" data-dismiss="modal">Close</button>
                                <input type="hidden" name="_method" value="PATCH">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('pagescript')
    <script>
        $(document).ready(function() {
            var table = $('#datatable').DataTable({
                dom: "<'top'f>rt<'row'<'col-2'i><'col-1'l><'col-9'p>>",
                searching: false,
                responsive: true,
                autoWidth: false,
                processing: true,
                serverSide: true,
                lengthMenu: [
                    [10, 100, 500, -1],
                    [10, 100, 500, "All"]
                ],
                language: {
                    paginate: {
                        previous: "<i class='fa-solid fa-chevron-left'></i>",
                        next: "<i class='fa-solid fa-chevron-right'></i>"
                    }
                },
                ajax:
                    {
                    url: "{{ route('level.index') }}",
                    data: function(d){
                        d.input_search = $('#input_search').val();
                    },
                },
                columns: [
                    {data: 'DT_RowIndex', name: 'DT_RowIndex'},
                    {data: 'name', name:'name'},
                    {data: 'level_order', name: 'level_order'},
                    {data: 'score', name: 'score'},
                    {data: 'total_question', name: 'total_question'}, 
                    {data: 'win_question_count', name: 'win_question_count'},
                    {data: 'action', orderable: false, searchable: false},
                ],
            });
            $('#input_search').keyup(function() {
                table.draw();
            });
        });

        function save_level(){
            var Check_Admin = '<?php echo Check_Admin_Access(); ?>';
            if(Check_Admin == 1){

                $("#dvloader").show();
                var formData = new FormData($("#save_level")[0]);
                $.ajax({
                    type:'POST',
                    url:'{{ route("level.store") }}',
                    data:formData,
                    cache:false,
                    contentType: false,
                    processData: false,
                    success:function(resp){
                        $("#dvloader").hide();
                        get_responce_message(resp, 'save_level', '{{ route("level.index") }}');
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        $("#dvloader").hide();
                        toastr.error(errorThrown.msg,'failed');         
                    }
                });
            } else {
                toastr.error('You have no right to add, edit, and delete.');
            }
		}

        $(document).on("click", ".edit_level", function() {
            var id = $(this).data('id');
            var name = $(this).data('name');
            var level_order = $(this).data('level_order');
            var score = $(this).data('score');
            var win_question_count = $(this).data('win_question_count');
            var total_question = $(this).data('total_question');

            $(".modal-body #edit_id").val(id);
            $(".modal-body #edit_name").val(name);
            $(".modal-body #edit_level_order").val(level_order);
            $(".modal-body #edit_score").val(score);
            $(".modal-body #edit_win_question_count").val(win_question_count);
            $(".modal-body #edit_total_question").val(total_question);
        });

        function update_level() {

            var Check_Admin = '<?php echo Check_Admin_Access(); ?>';
            if(Check_Admin == 1){

                $("#dvloader").show();
                var formData = new FormData($("#edit_level")[0]);

                var Edit_Id = $("#edit_id").val();
                var url = '{{ route("level.update", ":id") }}';
                    url = url.replace(':id', Edit_Id);

                $.ajax({
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    enctype: 'multipart/form-data',
                    type: 'POST',
                    url: url,
                    data: formData,
                    cache: false,
                    contentType: false,
                    processData: false,
                    success: function(resp) {
                        $("#dvloader").hide();

                        if(resp.status == 200){
                            $('#EditModel').modal('toggle');
                        }
                        get_responce_message(resp, 'edit_level', '{{ route("level.index") }}');
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        $("#dvloader").hide();
                        toastr.error(errorThrown.msg, 'failed');
                    }
                });
            } else {
                toastr.error('You have no right to add, edit, and delete.');
            }
        }
    </script>
@endsection