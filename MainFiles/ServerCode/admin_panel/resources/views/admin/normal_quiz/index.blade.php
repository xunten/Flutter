@extends('layout.page-app')
@section('page_title', __('Label.Normal_Question'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.Normal_Question')}}</h1>

            <div class="border-bottom row mb-3">
                <div class="col-sm-10">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a></li>
                        <li class="breadcrumb-item active" aria-current="page">{{__('Label.Normal_Question')}}</li>
                    </ol>
                </div>
                <div class="col-sm-2 d-flex align-items-center justify-content-end">
                    <a href="{{ route('normalquestion.create') }}" class="btn btn-default mw-150" style="margin-top:-14px">{{__('Label.Add_Normal_Question')}}</a>
                </div>
            </div>

            <!-- Import Question -->
            <div class="card custom-border-card mb-5">
                <h5 class="card-header">Import Question</h5>
                <div class="card-body">
                    <form enctype="multipart/form-data" id="save_question_import">
                        <div class="form-row mb-3">
                            <div class="col-md-2">
                                <label class="pt-3" style="font-size:16px; font-weight:500; color:#1b1b1b">Upload Question File</label>
                            </div>
                            <div class="col-md-5">
                                <input type="file" class="form-control import-file" id="import_file" name="import_file" accept=".csv" autofocus>
                            </div>
                        </div>
                        <div class="form-row pt-3">
                            <div class="col-md-2"></div>
                            <div class="col-md-6">
                                <button type="button" class="btn btn-default mw-120" onclick="save_question_import()">{{__('Label.UPLOAD CSV FILE')}}</button>
                                <a class="btn btn-warning ml-5" href="{{ route('normalquestion_export') }}">{{__('Label.DOWNLOAD SAMPLE FILE HERE')}}</a>
                                <input type="hidden" name="_token" value="{{ csrf_token() }}">
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Table -->
            <div class="card custom-border-card mb-5">
                <h5 class="card-header">Question List</h5>
                <div class="card-body">
                    <div class="page-search mb-3">
                        <div class="input-group" title="Search">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="basic-addon1"><i class="fa-solid fa-magnifying-glass fa-xl light-gray"></i></span>
                            </div>
                            <input type="text" id="input_search" class="form-control" placeholder="Search Question" aria-label="Search" aria-describedby="basic-addon1">
                        </div>
                        <div class="sorting mr-3" style="width: 400px;">
                            <label>Sort by :</label>
                            <select class="form-control" name="input_category" id="input_category">
                                <option value="0" selected>All Category</option>
                                @for ($i = 0; $i < count($category); $i++) <option value="{{ $category[$i]['id'] }}" @if(isset($_GET['input_category'])){{ $_GET['input_category'] == $user[$i]['id'] ? 'selected' : ''}} @endif>
                                    {{ $category[$i]['name'] }}
                                    </option>
                                    @endfor
                            </select>
                        </div>
                        <div class="sorting" style="width: 300px;">
                            <label>Sort by :</label>
                            <select class="form-control" name="input_level" id="input_level">
                                <option value="0" selected>All Level</option>
                                @for ($i = 0; $i < count($level); $i++) <option value="{{ $level[$i]['id'] }}" @if(isset($_GET['input_level'])){{ $_GET['input_level'] == $user[$i]['id'] ? 'selected' : ''}} @endif>
                                    {{ $level[$i]['name'] }}
                                    </option>
                                    @endfor
                            </select>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-striped text-center table-bordered" id="datatable">
                            <thead>
                                <tr style="background: #F9FAFF">
                                    <th>{{__('Label.#')}}</th>
                                    <th>{{__('Label.Image')}}</th>
                                    <th>{{__('Label.Category')}}</th>
                                    <th>{{__('Label.Level')}}</th>
                                    <th>{{__('Label.Question')}}</th>
                                    <th>{{__('Label.Option A')}}</th>
                                    <th>{{__('Label.Option B')}}</th>
                                    <th>{{__('Label.Option C')}}</th>
                                    <th>{{__('Label.Option D')}}</th>
                                    <th>{{__('Label.Answer')}}</th>
                                    <th>{{__('Label.Action')}}</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
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
                ajax: {
                    url: "{{ route('normalquestion.index') }}",
                    data: function(d) {
                        d.input_search = $('#input_search').val();
                        d.input_category = $('#input_category').val();
                        d.input_level = $('#input_level').val();
                    },
                },
                columns: [{
                        data: 'DT_RowIndex',
                        name: 'DT_RowIndex'
                    },
                    {
                        data: 'image',
                        orderable: false,
                        searchable: false,
                        render: function(data, type, full, meta) {
                            return "<a href='" + data + "' target='_blank' title='Watch'><img src='" + data + "' class='img-thumbnail' style='height:55px; width:55px'></a>";
                        },
                    },
                    {
                        data: 'category.name',
                        name: 'category.name',
                        render: function(data, type, full, meta) {
                            if (data) {
                                return data;
                            } else {
                                return "-";
                            }
                        },
                    },
                    {
                        data: 'level.name',
                        name: 'level.name',
                        render: function(data, type, full, meta) {
                            if (data) {
                                return data;
                            } else {
                                return "-";
                            }
                        },
                    },
                    {
                        data: 'question',
                        name: 'question'
                    },
                    {
                        data: 'option_a',
                        name: 'option_a'
                    },
                    {
                        data: 'option_b',
                        name: 'option_b'
                    },
                    {
                        data: 'option_c',
                        name: 'option_c',
                        render: function(data, type, full, meta) {
                            if (data) {
                                return data;
                            } else {
                                return "-";
                            }
                        },
                    },
                    {
                        data: 'option_d',
                        name: 'option_d',
                        render: function(data, type, full, meta) {
                            if (data) {
                                return data;
                            } else {
                                return "-";
                            }
                        },
                    },
                    {
                        data: 'answer',
                        name: 'answer',
                        render: function(data, type, full, meta) {
                            if (data == 1) {
                                return "A";
                            } else if (data == 2) {
                                return "B";
                            } else if (data == 3) {
                                return "C";
                            } else if (data == 4) {
                                return "D";
                            }
                        },
                    },
                    {
                        data: 'action',
                        orderable: false,
                        searchable: false
                    },
                ],
            });

            $('#input_category, #input_level').change(function() {
                table.draw();
            });
            $('#input_search').keyup(function() {
                table.draw();
            });
        });

        function save_question_import() {
            $("#dvloader").show();
            var formData = new FormData($("#save_question_import")[0]);
            $.ajax({
                type: 'POST',
                url: '{{ route("normalquestion_import") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    get_responce_message(resp, 'save_question_import', '{{ route("normalquestion.index") }}');
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
    </script>
@endsection