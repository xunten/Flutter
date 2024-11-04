@extends('layout.page-app')

@section('content')
    <div class="h-100">
        <div class="h-100 no-gutters row">

            <div class="d-none d-lg-block h-100 col-lg-5 col-xl-4">
                <div class="left-caption">
                    <img src="{{asset('assets/imgs/login.jpg')}}" class="bg-img" />
                    <div class="caption">
                        <div>
                            <!-- logo -->
                            <h1>{{ App_Name() }}</h1>
                            <?php $setting = settingData();?>
                            <p class="text">
                                {{string_cut($setting['app_desripation'], 200)}}
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="h-100 d-flex login-bg justify-content-center align-items-lg-center col-md-12 col-lg-7 col-xl-8">
                <div class="mx-auto col-sm-12 col-md-10 col-xl-8">
                    <div class="py-5 p-3">

                        <div class="app-logo mb-4">
                            <h1 class="primary-color mb-4 d-block d-lg-none">{{ App_Name() }}</h1>
                            <h3 class="primary-color mb-0 font-weight-bold">Login</h3>
                        </div>

                        <h4 class="mb-0 font-weight-bold">
                            <span class="d-block mb-2">Welcome back,</span>
                            <span>Please sign in to your account.</span>
                        </h4>

                        <form method="POST" id="login_form">
                            <div class="form-row mt-4">
                                <div class="col-md-6">
                                    <div class="position-relative form-group">
                                        <label>Email</label>
                                        <input name="email" placeholder="Email here..." type="email" class="form-control" value="" required autofocus>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="position-relative form-group">
                                        <label>Password</label>
                                        <input name="password" placeholder="Password here..." type="password" class="form-control" value="" required>
                                    </div>
                                </div>
                            </div>
                            <div class="custom-control custom-checkbox mr-sm-2">
                                <input type="checkbox" class="custom-control-input" id="customControlAutosizing" name="remember">
                                <label class="custom-control-label" for="customControlAutosizing">Keep me logged in</label>
                            </div>
                            <div class="form-row mt-4">
                                <div class="col-sm-6 text-center text-sm-left">
                                    <button class="btn btn-default my-3 mw-120" onclick="save_login()" type="button">Login</button>
                                </div>
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
        // Login Form
        function save_login() {
            $("#dvloader").show();
            var formData = new FormData($("#login_form")[0]);
            $.ajax({
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                type: 'POST',
                url: '{{ route("adminLoginPost") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    get_responce_message(resp, 'login_form', '{{ route("dashboard") }}');
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
    </script>
@endsection