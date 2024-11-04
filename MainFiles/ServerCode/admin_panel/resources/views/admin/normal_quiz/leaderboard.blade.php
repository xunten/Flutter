@extends('layout.page-app')
@section('page_title', __('Label.Normal_Leaderboard'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.Normal_Leaderboard')}}</h1>

            <div class="border-bottom row mb-3">
                <div class="col-sm-12">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a></li>
                        <li class="breadcrumb-item active" aria-current="page">{{__('Label.Normal_Leaderboard')}}</li>
                    </ol>
                </div>
            </div>

            <!-- Search && Table -->
            <div class="page-search mb-3">
                <div class="sorting">
                    <label>Sort by :</label>
                    <select class="form-control" id="input_type">
                        <option value="all">All</option>
                        <option value="today">Today</option>
                        <option value="month">Month</option>
                        <option value="year">Year</option>
                    </select>
                </div>
            </div>

            <div class="table-responsive table">
                <table class="table table-striped text-center table-bordered" id="datatable">
                    <thead>
                        <tr style="background: #F9FAFF;">
                            <th> {{__('Label.Rank')}} </th>
                            <th> {{__('Label.Score')}} </th>
                            <th> {{__('Label.Image')}} </th>
                            <th> {{__('Label.Name')}} </th>
                            <th> {{__('Label.Email')}} </th>
                            <th> {{__('Label.Mobile')}} </th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
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
                    url: "{{ route('normalleaderboard') }}",
                    data: function(d) {
                        d.input_type = $('#input_type').val();
                    },
                },
                columns: [{
                        data: 'rank',
                        name: 'rank'
                    },
                    {
                        data: 'total_score',
                        name: 'total_score'
                    },
                    {
                        data: 'users.profile_img',
                        orderable: false,
                        searchable: false,
                        render: function(data, type, full, meta) {
                            if (data) {
                                return "<a href='" + data + "' target='_blank' title='Watch'><img src='" + data + "' class='rounded-circle' style='height:55px; width:55px'></a>";
                            } else {
                                return "<a href='{{asset('assets/imgs/default.png')}}' target='_blank' title='Watch'><img src='{{asset('assets/imgs/default.png')}}' class='rounded-circle' style='height:55px; width:55px'></a>";
                            }
                        },
                    },
                    {
                        data: 'users.fullname',
                        name: 'users.fullname',
                        render: function(data, type, full, meta) {
                            if (data) {
                                return data;
                            } else {
                                return "-";
                            }
                        }
                    },
                    {
                        data: 'users.email',
                        name: 'users.email',
                        render: function(data, type, full, meta) {
                            if (data) {
                                return data;
                            } else {
                                return "-";
                            }
                        }
                    },
                    {
                        data: 'users.mobile_number',
                        name: 'users.mobile_number',
                        render: function(data, type, full, meta) {
                            if (data) {
                                return data;
                            } else {
                                return "-";
                            }
                        }
                    },
                ],
            });

            $('#input_type').change(function() {
                table.draw();
            });
        });
    </script>
@endsection