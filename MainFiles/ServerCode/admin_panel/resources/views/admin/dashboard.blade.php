@extends('layout.page-app')
@section('page_title', __('Label.Dashboard'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">@yield('title')</h1>

            <!-- Counter -->
            <div class="row counter-row">
                <div class="col-6 col-sm-4 col-md col-lg-4 col-xl">
                    <div class="db-color-card user-card">
                        <i class="fa-solid fa-users fa-4x card-icon"></i>
                        <div class="dropdown dropright">
                            <a href="#" class="btn head-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fa-solid fa-ellipsis-vertical fa-xl text-dark dot-icon mr-2"></i>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <a class="dropdown-item" href="{{ route('user.index') }}" style="color: #A98471;">{{__('Label.View All')}}</a>
                            </div>
                        </div>
                        <h2 class="counter">
                            <p class="p-0 m-0 counting" data-count="{{no_format($total_user ?? 0)}}">{{no_format($total_user ?? 0)}}</p>
                            <span>{{__('Label.Users')}}</span>
                        </h2>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-md col-lg-4 col-xl">
                    <div class="db-color-card cate-card">
                        <i class="fa-solid fa-list fa-4x card-icon"></i>
                        <div class="dropdown dropright">
                            <a href="#" class="btn head-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fa-solid fa-ellipsis-vertical fa-xl text-dark dot-icon mr-2"></i>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <a class="dropdown-item" href="{{ route('category.index') }}" style="color: #736AA6">{{__('Label.View All')}}</a>
                            </div>
                        </div>
                        <h2 class="counter">
                            <p class="p-0 m-0 counting" data-count="{{no_format($total_category ?? 0)}}">{{no_format($total_category ?? 0)}}</p>
                            <span>{{__('Label.Category')}}</span>
                        </h2>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-md col-lg-4 col-xl">
                    <div class="db-color-card artist-card">
                        <i class="fa-solid fa-signal fa-4x card-icon"></i>
                        <div class="dropdown dropright">
                            <a href="#" class="btn head-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fa-solid fa-ellipsis-vertical fa-xl text-dark dot-icon mr-2"></i>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <a class="dropdown-item" href="{{ route('level.index') }}" style="color: #6DB3C6">{{__('Label.View All')}}</a>
                            </div>
                        </div>
                        <h2 class="counter">
                            <p class="p-0 m-0 counting" data-count="{{no_format($total_level ?? 0)}}">{{no_format($total_level ?? 0)}}</p>
                            <span>{{__('Label.Level')}}</span>
                        </h2>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-md col-lg-4 col-xl">
                    <div class="db-color-card package-card">
                        <i class="fa-solid fa-circle-question fa-4x card-icon"></i>
                        <div class="dropdown dropright">
                            <a href="#" class="btn head-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fa-solid fa-ellipsis-vertical fa-xl text-dark dot-icon mr-2"></i>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <a class="dropdown-item" href="{{ route('normalquestion.index') }}" style="color: #C0698B">{{__('Label.View All')}}</a>
                            </div>
                        </div>
                        <h2 class="counter">
                            <p class="p-0 m-0 counting" data-count="{{no_format($total_question ?? 0)}}">{{no_format($total_question ?? 0)}}</p>
                            <span>{{__('Label.Question')}}</span>
                        </h2>
                    </div>
                </div>
            </div>

            <!-- Counter -->
            <div class="row counter-row">
                <div class="col-6 col-sm-4 col-md col-lg-4 col-xl">
                    <div class="db-color-card subscribers-card">
                        <i class="fa-solid fa-money-bill fa-4x card-icon"></i>
                        <div class="dropdown dropright">
                            <a href="#" class="btn head-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fa-solid fa-ellipsis-vertical fa-xl text-dark dot-icon mr-2"></i>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <a class="dropdown-item" href="{{ route('transaction.index')}}" style="color: #530899">{{__('Label.View All')}}</a>
                            </div>
                        </div>
                        <h2 class="counter">
                            <p class="p-0 m-0 counting" data-count="{{no_format($total_earning) ?: 00}}">{{no_format($total_earning) ?: 00}}</p>
                            <span>Earnings ({{currency_code()}})</span>
                        </h2>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-md col-lg-4 col-xl">
                    <div class="db-color-card green-card">
                        <i class="fa-regular fa-money-bill-1 fa-4x card-icon"></i>
                        <div class="dropdown dropright">
                            <a href="#" class="btn head-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fa-solid fa-ellipsis-vertical fa-xl text-dark dot-icon mr-2"></i>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <a class="dropdown-item" href="{{ route('transaction.index')}}" style="color: #245c1c">{{__('Label.View All')}}</a>
                            </div>
                        </div>
                        <h2 class="counter">
                            <p class="p-0 m-0 counting" data-count="{{no_format($total_this_month_earning ?? 0)}}">{{no_format($total_this_month_earning ?? 0)}}</p>
                            <span>This Month ({{currency_code()}})</span>
                        </h2>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-md col-lg-4 col-xl">
                    <div class="db-color-card plan-card">
                        <i class="fa-solid fa-box-archive fa-4x card-icon"></i>
                        <div class="dropdown dropright">
                            <a href="#" class="btn head-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fa-solid fa-ellipsis-vertical fa-xl text-dark dot-icon mr-2"></i>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <a class="dropdown-item" href="{{ route('package.index') }}" style="color: #201f1e">{{__('Label.View All')}}</a>
                            </div>
                        </div>
                        <h2 class="counter">
                            <p class="p-0 m-0 counting" data-count="{{no_format($total_package ?: 00)}}">{{no_format($total_package ?: 00)}}</p>
                            <span>Package</span>
                        </h2>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-md col-lg-4 col-xl">
                    <div class="db-color-card category-card">
                        <i class="fa-solid fa-list-check fa-4x card-icon"></i>
                        <div class="dropdown dropright">
                            <a href="#" class="btn head-btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fa-solid fa-ellipsis-vertical fa-xl text-dark dot-icon mr-2"></i>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <a class="dropdown-item" href="{{ route('contests.index')}}" style="color:#9D0BB1;">{{__('Label.View All')}}</a>
                            </div>
                        </div>
                        <h2 class="counter">
                            <p class="p-0 m-0 counting" data-count="{{no_format($total_contest ?? 0)}}">{{no_format($total_contest ?? 0)}}</p>
                            <span>{{__('Label.Contest')}}</span>
                        </h2>
                    </div>
                </div>
            </div>

            <!-- Join User Statistice && Upcomming Contest -->
            <div class="row">
                <div class="col-12 col-xl-8">
                    <div class="box-title">
                        <h2 class="title">Join Users Statistice</h2>
                        <a href="{{ route('user.index') }}" class="btn btn-link">{{__('Label.View All')}}</a>
                    </div>
                    <div class="row mt-2 mb-2">
                        <div class="col-12 col-sm-12">
                            <Button id="year" class="btn btn-default">This Year</Button>
                            <Button id="month" class="btn btn-default">This Month</Button>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 col-sm-12">
                            <canvas id="UserChart" width="100%" height="42px" style="background-color: #f9faff;"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-xl-4">
                    <div class="video-box">
                        <div class="box-title mt-0">
                            <h2 class="title">{{__('Label.UpComming Contest')}}</h2>
                            <a href="{{ route('contests.index') }}" class="btn btn-link">{{__('Label.View All')}}</a>
                        </div>
                        <div class="p-3 bg-white mt-4">
                            @foreach ($upcomming_contest as $value)
                            <img src="{{$value->image}}" class="img-fluid d-block mx-auto img-thumbnail" style="height: 300px; width: 100%;">
                            <div class="box-title box-border-0 d-flex">
                                <h5 class="f600" style="display: inline-block; text-overflow:ellipsis; white-space:nowrap; overflow:hidden; width:75%;">{{$value->name}}</h5>
                                <button class="btn btn-success btn-sm ">{{currency_code()}} {{$value->price}}</button>
                            </div>
                            <p id="demo" style="color:#4e45b8; font-size:18px" class="font-weight-bold mt-2 mb-0 text-center"></p>
                            @break
                            @endforeach
                        </div>
                    </div>
                </div>
            </div>

            <!-- Top Performer -->
            <div class="row">
                <div class="col-12">

                    <div class="box-title">
                        <h2 class="title">Top Performer</h2>
                    </div>
                    <div class="row artist-row">
                        @if(isset($pratice_quiz_top_user) && $pratice_quiz_top_user != null)
                        <div class="col-6 col-md-2">
                            <div class="artist-grid-card pt-0">
                                <p class="box-title" style="font-size: 20px; font-weight: 600;">Pratice Quiz</p>
                                <span class="avatar-control">
                                    @isset($pratice_quiz_top_user->users->profile_img)
                                    <img src="{{ $pratice_quiz_top_user->users->profile_img }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @else
                                    <img src="{{ asset('assets/imgs/default.png') }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @endif
                                </span>
                                <h3 class="name" style="display: inline-block; text-overflow:ellipsis; white-space:nowrap; overflow:hidden; width:100%;">{{ $pratice_quiz_top_user->users->fullname ?? "-" }}</h3>
                                <p class="post mb-1">Score : {{ round($pratice_quiz_top_user->total_score) }}</p>
                            </div>
                        </div>
                        @endif
                        @if(isset($normal_quiz_top_user) && $normal_quiz_top_user != null)
                        <div class="col-6 col-md-2">
                            <div class="artist-grid-card pt-0">
                                <p class="box-title" style="font-size: 20px; font-weight: 600;">Normal Quiz</p>
                                <span class="avatar-control">
                                    @isset($normal_quiz_top_user->users->profile_img)
                                    <img src="{{ $normal_quiz_top_user->users->profile_img }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @else
                                    <img src="{{ asset('assets/imgs/default.png') }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @endif
                                </span>
                                <h3 class="name" style="display: inline-block; text-overflow:ellipsis; white-space:nowrap; overflow:hidden; width:100%;">{{ $normal_quiz_top_user->users->fullname ?? "-" }}</h3>
                                <p class="post mb-1">Score : {{ round($normal_quiz_top_user->total_score) }}</p>
                            </div>
                        </div>
                        @endif
                        @if(isset($daily_quiz_top_user) && $daily_quiz_top_user != null)
                        <div class="col-6 col-md-2">
                            <div class="artist-grid-card pt-0">
                                <p class="box-title" style="font-size: 20px; font-weight: 600;">Daily Quiz</p>
                                <span class="avatar-control">
                                    @isset($daily_quiz_top_user->users->profile_img)
                                    <img src="{{ $daily_quiz_top_user->users->profile_img }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @else
                                    <img src="{{ asset('assets/imgs/default.png') }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @endif
                                </span>
                                <h3 class="name" style="display: inline-block; text-overflow:ellipsis; white-space:nowrap; overflow:hidden; width:100%;">{{ $daily_quiz_top_user->users->fullname ?? "-" }}</h3>
                                <p class="post mb-1">Score : {{ round($daily_quiz_top_user->total_score) }}</p>
                            </div>
                        </div>
                        @endif
                        @if(isset($true_false_quiz_top_user) && $true_false_quiz_top_user != null)
                        <div class="col-6 col-md-2">
                            <div class="artist-grid-card pt-0">
                                <p class="box-title" style="font-size: 20px; font-weight: 600;">True/False Quiz</p>
                                <span class="avatar-control">
                                    @isset($true_false_quiz_top_user->users->profile_img)
                                    <img src="{{ $true_false_quiz_top_user->users->profile_img }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @else
                                    <img src="{{ asset('assets/imgs/default.png') }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @endif
                                </span>
                                <h3 class="name" style="display: inline-block; text-overflow:ellipsis; white-space:nowrap; overflow:hidden; width:100%;">{{ $true_false_quiz_top_user->users->fullname ?? "-" }}</h3>
                                <p class="post mb-1">Score : {{ round($true_false_quiz_top_user->total_score) }}</p>
                            </div>
                        </div>
                        @endif
                        @if(isset($audio_quiz_top_user) && $audio_quiz_top_user != null)
                        <div class="col-6 col-md-2">
                            <div class="artist-grid-card pt-0">
                                <p class="box-title" style="font-size: 20px; font-weight: 600;">Audio Quiz</p>
                                <span class="avatar-control">
                                    @isset($audio_quiz_top_user->users->profile_img)
                                    <img src="{{ $audio_quiz_top_user->users->profile_img }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @else
                                    <img src="{{ asset('assets/imgs/default.png') }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @endif
                                </span>
                                <h3 class="name" style="display: inline-block; text-overflow:ellipsis; white-space:nowrap; overflow:hidden; width:100%;">{{ $audio_quiz_top_user->users->fullname ?? "-" }}</h3>
                                <p class="post mb-1">Score : {{ round($audio_quiz_top_user->total_score) }}</p>
                            </div>
                        </div>
                        @endif
                        @if(isset($video_quiz_top_user) && $video_quiz_top_user != null)
                        <div class="col-6 col-md-2">
                            <div class="artist-grid-card pt-0">
                                <p class="box-title" style="font-size: 20px; font-weight: 600;">Video Quiz</p>
                                <span class="avatar-control">
                                    @isset($video_quiz_top_user->users->profile_img)
                                    <img src="{{ $video_quiz_top_user->users->profile_img }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @else
                                    <img src="{{ asset('assets/imgs/default.png') }}" class="img-thumbnail" style="height: 180px; width: 100%; border-radius: 25px" />
                                    @endif
                                </span>
                                <h3 class="name" style="display: inline-block; text-overflow:ellipsis; white-space:nowrap; overflow:hidden; width:100%;">{{ $video_quiz_top_user->users->fullname ?? "-" }}</h3>
                                <p class="post mb-1">Score : {{ round($video_quiz_top_user->total_score) }}</p>
                            </div>
                        </div>
                        @endif
                    </div>
                </div>
            </div>

            <!-- Plan Earning Statistice -->
            <div class="row">
                <div class="col-12">
                    <div class="box-title">
                        <h2 class="title">Plan Earning Statistice</h2>
                        <a href="{{ route('transaction.index') }}" class="btn btn-link">{{__('Label.View All')}}</a>
                    </div>
                    <div class="row">
                        <div class="col-12 col-sm-12">
                            <canvas id="MyChart" width="100%" height="30px" style="background-color: #f9faff;"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('pagescript')
    <script>
        // Plan Earning Statistice
        $(function() {
            //get the pie chart canvas
            var cData = JSON.parse(`<?php echo $package; ?>`);
            var ctx = $("#MyChart");
            var month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
            var backcolor = ["#EF2648", "#5A8A91", "#ffa300", "#6D3A74", "#2A445E", "#00bfa0", "#9b19f5", "#b30000"];

            const datasetValue = [];
            for (let i = 0; i < cData['label'].length; i++) {
                datasetValue[i] = {
                    label: cData['label'][i],
                    data: cData['sum'][i],
                    backgroundColor: backcolor[i],
                }
            }

            //bar chart data
            var data = {
                labels: month,
                datasets: datasetValue
            };

            //options
            var options = {
                responsive: true,
                title: {
                    display: true,
                    position: "top",
                    text: "Plan Earning Statistice (Current Year)",
                    fontSize: 18,
                    fontColor: "#000"
                },
                legend: {
                    title: "text",
                    display: true,
                    position: 'top',
                    labels: {
                        fontSize: 16,
                        fontColor: "#000000",
                    }
                },
                scales: {
                    yAxes: [{
                        scaleLabel: {
                            display: true,
                            labelString: 'Amount',
                            fontSize: 16,
                            fontColor: "#000000",
                        },
                    }],
                    xAxes: [{
                        scaleLabel: {
                            display: true,
                            labelString: 'Month',
                            fontSize: 16,
                            fontColor: "#000000",
                        }
                    }]
                }
            };

            //create bar Chart class object
            var chart1 = new Chart(ctx, {
                type: "bar",
                data: data,
                options: options
            });
        });

        // User Statistice
        var cData = JSON.parse(`<?php echo $user_year; ?>`);
        var ctx = $("#UserChart");
        var month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

        var data = {
            labels: month,
            datasets: [{
                label: 'Users',
                data: cData['sum'],
                backgroundColor: '#4e45b8',
            }],
        };
        var options = {
            responsive: true,
            title: {
                display: true,
                position: "top",
                text: "Join Users Statistice (Current Year)",
                fontSize: 18,
                fontColor: "#000"
            },
            legend: {
                title: "text",
                display: true,
                position: 'top',
                labels: {
                    fontSize: 16,
                    fontColor: "#000000",
                }
            },
            scales: {
                yAxes: [{
                    scaleLabel: {
                        display: true,
                        labelString: 'Total Count',
                        fontSize: 16,
                        fontColor: "#000000",
                    },
                }],
                xAxes: [{
                    scaleLabel: {
                        display: true,
                        labelString: 'Month',
                        fontSize: 16,
                        fontColor: "#000000",
                    }
                }]
            }
        };
        var chart1 = new Chart(ctx, {
            type: "bar",
            data: data,
            options: options
        });

        $("#year").on("click", function() {
            chart1.destroy();

            chart1 = new Chart(ctx, {
                type: "bar",
                data: data,
                options: options

            });
        });
        $("#month").on("click", function() {

            var date = new Date();
            var currentYear = date.getFullYear();
            var currentMonth = date.getMonth() + 1;
            const getDays = (year, month) => new Date(year, month, 0).getDate();
            const days = getDays(currentYear, currentMonth);

            var all1 = [];
            for (let i = 0; i < days; i++) {
                all1.push(i + 1);
            }

            chart1.destroy();
            var cData = JSON.parse(`<?php echo $user_month ?>`);

            var data = {
                labels: all1,
                datasets: [{
                    label: 'Users',
                    data: cData['sum'],
                    backgroundColor: '#4e45b8',
                }],
            };
            var options = {
                responsive: true,
                title: {
                    display: true,
                    position: "top",
                    text: "Join Users Statistice (Current Month)",
                    fontSize: 18,
                    fontColor: "#000"
                },
                legend: {
                    title: "text",
                    display: true,
                    position: 'top',
                    labels: {
                        fontSize: 16,
                        fontColor: "#000000",
                    }
                },
                scales: {
                    yAxes: [{
                        scaleLabel: {
                            display: true,
                            labelString: 'Total Count',
                            fontSize: 16,
                            fontColor: "#000000",
                        },
                    }],
                    xAxes: [{
                        scaleLabel: {
                            display: true,
                            labelString: 'Date',
                            fontSize: 16,
                            fontColor: "#000000",
                        }
                    }]
                }
            };
            chart1 = new Chart(ctx, {
                type: "bar",
                data: data,
                options: options,
            });
        });

        // Contest Timer
        @if(isset($upcomming_contest))
            @foreach($upcomming_contest as $value)

                var countDownDate = new Date("{{$value->start_date}}").getTime();

                var x = setInterval(function() {

                    var now = new Date().getTime();
                    var distance = countDownDate - now;

                    var days = Math.floor(distance / (1000 * 60 * 60 * 24));
                    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                    var seconds = Math.floor((distance % (1000 * 60)) / 1000);

                    document.getElementById("demo").innerHTML = days + "d " + hours + "h " + minutes + "m " + seconds + "s ";
                    if (distance < 0) {
                        clearInterval(x);
                        document.getElementById("demo").innerHTML = "LIVE";
                    }
                }, 1000);
                @break
            @endforeach
        @endif
    </script>
@endsection