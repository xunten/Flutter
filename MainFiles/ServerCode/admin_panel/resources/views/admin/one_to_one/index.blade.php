@extends('layout.page-app')

@section('page_title',  __('Label.Challenges'))

@section('content')
  @include('layout.sidebar')

  <div class="right-content">
    @include('layout.header')
 
    <div class="body-content">
      <!-- mobile title -->
      <h1 class="page-title-sm">{{__('Label.Challenges')}}</h1>

      <div class="border-bottom row mb-3">
        <div class="col-sm-12">
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a></li>
            <li class="breadcrumb-item active" aria-current="page">
              {{__('Label.Challenges')}}
            </li>
          </ol>
        </div>
      </div>

      <div class="mb-3">
        <form class="" action="{{ route('one_to_one_challenge')}}" method="GET">
          <div class="form-row">
            <div class="col-md-1 d-flex align-items-center">
              <label for="type">{{__('Label.SEARCH')}} :</label>
            </div>
            <div class="col-md-2">
              <div class="form-group">
                <select class="form-control" id="type" name="type">
                  <option value="" disabled>{{__('Label.Select Type')}}</option>
                  <option value="today" @if(isset($_GET['type'])){{ $_GET['type'] == "today" ? 'selected' : ''}}  @endif > {{__('Label.Today')}} </option>
                  <option value="month" @if(isset($_GET['type'])){{ $_GET['type'] == "month" ? 'selected' : ''}}  @endif> {{__('Label.Month')}} </option>
                  <option value="all" @if(isset($_GET['type'])){{ $_GET['type'] == "all" ? 'selected' : ''}} @else selected @endif> {{__('Label.All')}} </option>
                </select>
              </div>
            </div>
            <div class="col-sm-2 ml-4">
              <button class="btn btn-default" type="submit"> {{__('Label.SEARCH')}} </button>
            </div>
          </div>
        </form>
      </div>

      <div class="table-responsive">
        <table class="table table-striped challenge-table text-center table-bordered">
          <thead>
            <tr style="background: #F9FAFF;">
              <th> {{__('Label.#')}} </th>
              <th> {{__('Label.Room Id')}} </th>
              <th> {{__('Label.Category')}} </th>
              <th> {{__('Label.Name')}} </th>
              <th> {{__('Label.Created Name')}} </th>
              <th> {{__('Label.Joined Name')}} </th>
              <th> {{__('Label.Start Time')}} </th>
              <th> {{__('Label.End Time')}} </th>
              <th> {{__('Label.Total Question')}} </th>
              <th> {{__('Label.Is Paid')}} </th>
              <th> {{__('Label.Point')}} </th>
              <th> {{__('Label.Is Full')}} </th>
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
      $(function () {

        @if(isset($_GET['type']) != null)
          var type = '<?php echo $_GET['type']; ?>'; 
        @endif

        var url = "{{route('one_to_one_challenge', '')}}"+"/"+type;

        var table = $('.challenge-table').DataTable({
          "responsive": true,
          "autoWidth": false,
          language: {
            paginate: {
              previous: "<img src='{{url('assets/imgs/left-arrow.png')}}' >",
              next: "<img src='{{url('assets/imgs/left-arrow.png')}}' style='transform: rotate(180deg)'>"
            }
          },
          processing: true,
          serverSide: true,
          ajax: url,
          columns: [
            {data: 'DT_RowIndex', name: 'DT_RowIndex', visible: false},
            {data: 'room_id', name: 'room_id'},
            {data: 'category.name', name: 'category.name'},
            {data: 'name', name: 'name'},
            {data: 'c_user.username', name: 'c_user.username',
              "render": function (data, type, full, meta) {
                if(data){
                  return data;
                } else {
                  return "-";
                }
              },
            },
            {data: 'j_user.username', name: 'j_user.username',
              "render": function (data, type, full, meta) {
                if(data){
                  return data;
                } else {
                  return "-";
                }
              },
            },
            {data: 'start_date', name: 'start_date'},
            {data: 'end_date', name: 'end_date'},
            {data: 'total_question', name:'total_question'},
            {data: 'is_paid', name:'is_paid',
              "render": function (data, type, full, meta) {
                if(data == 0){
                  return "No";
                } else if (data == 1) {
                  return "Yes";
                } else {
                  return "-";
                }
              },
            },
            {data: 'point', name:'point',
              "render": function (data, type, full, meta) {
                if(data != 0){
                  return data;
                } else {
                  return "-";
                }
              },
            },
            {data: 'is_full', name:'is_full',
              "render": function (data, type, full, meta) {
                if(data == 0){
                  return "<button class='btn text-white pl-3 pr-3 p-1' style='background:#ff9700; font-size:14px;font-weight: bold;'> NO </button>";
                } else if (data == 1) {
                  return "<button class='btn text-white pl-3 pr-3 p-1' style='background:#15ca20; font-size:14px;font-weight: bold;'> YES </button>";
                } else {
                  return "-";
                }
              },
            },
          ],
        });
      });
    });
  </script>
@endsection