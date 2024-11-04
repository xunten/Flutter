@extends('layout.page-app')
@section('page_title', __('Label.Withdrawal Request'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.Withdrawal Request')}}</h1>

            <div class="border-bottom row mb-3">
                <div class="col-sm-12">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a></li>
                        <li class="breadcrumb-item active" aria-current="page">{{__('Label.Withdrawal Request')}}</li>
                    </ol>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-striped text-center table-bordered" id="datatable">
                    <thead>
                        <tr style="background: #F9FAFF;">
                            <th>{{__('Label.#')}}</th>
                            <th>{{__('Label.Image')}}</th>
                            <th>{{__('Label.Name')}}</th>
                            <th>{{__('Label.Point')}}</th>
                            <th>{{__('Label.Amount')}}</th>
                            <th>{{__('Label.Type')}}</th>
                            <th>{{__('Label.Detail')}}</th>
                            <th>{{__('Label.Date')}}</th>
                            <th>{{__('Label.Action')}}</th>
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
                responsive: true,
                autoWidth: false,
                language: {
                    paginate: {
                        previous: "<i class='fa-solid fa-chevron-left'></i>",
                        next: "<i class='fa-solid fa-chevron-right'></i>"
                    }
                },
                processing: true,
                serverSide: true,
                ajax: "{{ route('withdrawal.index') }}",
                columns: [{
                        data: 'DT_RowIndex',
                        name: 'DT_RowIndex'
                    },
                    {
                        data: 'profile_img',
                        orderable: false,
                        searchable: false,
                        render: function(data, type, full, meta) {
                            return "<a href='" + data + "' target='_blank' title='Watch'><img src='" + data + "' class='rounded-circle' style='height:55px; width:55px'></a>";
                        },
                    },
                    {
                        data: 'users.fullname',
                        name: 'users.fullname',
                        orderable: false,
                        render: function(data, type, full, meta) {
                            if (data) {
                                return data;
                            } else {
                                return "-";
                            }
                        },
                    },
                    {
                        data: 'point',
                        name: 'point'
                    },
                    {
                        data: 'total_amount',
                        name: 'total_amount'
                    },
                    {
                        data: 'payment_type',
                        name: 'payment_type',
                        orderable: false,
                        searchable: false,
                    },
                    {
                        data: 'payment_detail',
                        name: 'payment_detail',
                        orderable: false,
                        searchable: false,
                    },
                    {
                        data: 'date',
                        name: 'date'
                    },
                    {
                        data: 'action',
                        searchable: false,
                    },
                ],
            });
        });

        function change_status(id, status) {
            $("#dvloader").show();
            var url = "{{route('withdrawal.show', '')}}" + "/" + id;
            $.ajax({
                type: "GET",
                url: url,
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                data: id,
                success: function(resp) {
                    $("#dvloader").hide();

                    if (resp.status == 200) {
                        if (resp.Status_Code == 1) {

                            $('#' + id).text('Completed');
                            $('#' + id).css({
                                "background": "#4e45b8",
                                "font-weight": "bold",
                                "border": "none",
                                "color": "white",
                                "outline": "none",
                                "border-radius": "5px",
                                "cursor": "pointer",
                                "padding": "4px 10px",
                            });
                        } else {

                            $('#' + id).text('Pending');
                            $('#' + id).css({
                                "background": "#4e45b8",
                                "font-weight": "bold",
                                "border": "none",
                                "color": "white",
                                "padding": "4px 20px",
                                "outline": "none",
                                "border-radius": "5px",
                            });
                        }
                    } else {
                        toastr.error(resp.errors);
                    }
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        };
    </script>
@endsection