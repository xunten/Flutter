@extends('layout.page-app')

@section('page_title',  __('Label.Challenges Leaderboard'))

@section('content')
  @include('layout.sidebar')

  <div class="right-content">
    @include('layout.header')
 
    <div class="body-content">
      <!-- mobile title -->
      <h1 class="page-title-sm">{{__('Label.Challenges Leaderboard')}}</h1>
      <div class="border-bottom row mb-3">
        <div class="col-sm-12">
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
              {{__('Label.Leaderboard')}}
            </li>
          </ol>
        </div>
      </div>

      <div class="mb-3">
        <form class="" action="{{ route('one_to_one_leaderboard')}}" method="GET">
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
        <table class="table table-striped leaderboard-table text-center table-bordered">
          <thead>
            <tr style="background: #F9FAFF;">
              <th> {{__('Label.#')}} </th>
              <th> {{__('Label.Room Id')}} </th>
              <th> {{__('Label.Winning Amount')}} </th>
              <th> {{__('Label.Winner Name')}} </th>
              <th> {{__('Label.Loser Name')}} </th>
              <th> {{__('Label.Date')}} </th>
              <th> {{__('Label.Status')}} </th>
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

        var url = "{{route('one_to_one_leaderboard', '')}}"+"/"+type;

        var table = $('.leaderboard-table').DataTable({
          "responsive": true,
          "autoWidth": false,
          language: {
            paginate: {
              previous: "<img src='{{url('assets/imgs/left-arrow.png')}}' >",
              next: "<img src='{{url('assets/imgs/left-arrow.png')}}' style='transform: rotate(180deg)'>"
            }
          },
          processing: true,
          serverSide: false,
          ajax: url,
          columns: [
            {data: 'DT_RowIndex', name: 'DT_RowIndex', visible: false},
            {data: 'room_id', name: 'room_id'},
            {data: 'winning_amount', name: 'winning_amount'},
            {data: 'w_user.username', name: 'w_user.username',
              "render": function (data, type, full, meta) {
                if(data){
                  return data;
                } else {
                  return "-";
                }
              },
            },
            {data: 'l_user.username', name: 'l_user.username',
              "render": function (data, type, full, meta) {
                if(data){
                  return data;
                } else {
                  return "-";
                }
              },
            },
            {data: 'date', name: 'date'},
            {data: 'status', name: 'status',
              "render": function (data, type, full, meta) {
                if(data == 0){
                  return "<button class='btn text-white pl-3 pr-3 p-1' style='background:#0dceec; font-size:14px;font-weight: bold;'>Draw </button>";
                } else if(data == 1) {
                  return "<button class='btn text-white p-1' style='background:#15ca20; font-size:14px;font-weight: bold;'> Completed </button>";
                } else if(data == 2){
                  return "<button class='btn text-white p-1' style='background:#ff9700;font-size:14px;font-weight: bold;'> Not Completed </button>";
                }
              },
            },
          ],
        });
      });
    });
  </script>
@endsection
