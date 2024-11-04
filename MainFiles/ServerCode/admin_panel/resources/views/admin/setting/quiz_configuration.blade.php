@extends('layout.page-app')
@section('page_title',  __('Label.quiz_configuration'))

@section('content')
    @include('layout.sidebar')

    <div class="right-content">
        @include('layout.header')

        <div class="body-content">
            <!-- mobile title -->
            <h1 class="page-title-sm">{{__('Label.quiz_configuration')}}</h1>

            <div class="border-bottom row mb-3">
                <div class="col-sm-12">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="{{ route('dashboard') }}">{{__('Label.Dashboard')}}</a></li>
                        <li class="breadcrumb-item active" aria-current="page">{{__('Label.quiz_configuration')}}</li>
                    </ol>
                </div>
            </div>

            <form id="save_configuration">
                <input type="hidden" name="_token" value="{{ csrf_token() }}">
                <label class="mt-1">Note :- Please enter a value greater than or equal to 1</label>

                <div class="card custom-border-card">
                    <h5 class="card-header">{{__('Label.Audio_Quiz')}}</h5>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Quiz_Question')}}</label>
                                    <input name="audio_question" type="number" value="{{$quiz_configuration['audio_question']}}" min="0" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Manimum_Winning_Percentage')}}</label>
                                    <input name="min_audio_percentage" type="number" value="{{$quiz_configuration['min_audio_percentage']}}" min="0" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Winnging_Point')}}</label>
                                    <input name="audio_win_point" type="number" value="{{$quiz_configuration['audio_win_point']}}" min="0" class="form-control">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card custom-border-card">
                    <h5 class="card-header">{{__('Label.Video_Quiz')}}</h5>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Quiz_Question')}}</label>
                                    <input name="video_question" type="number" value="{{$quiz_configuration['video_question']}}" min="0" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Manimum_Winning_Percentage')}}</label>
                                    <input name="min_video_percentage" type="number" value="{{$quiz_configuration['min_video_percentage']}}" min="0" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Winnging_Point')}}</label>
                                    <input name="video_win_point" type="number" value="{{$quiz_configuration['video_win_point']}}" min="0" class="form-control">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card custom-border-card">
                    <h5 class="card-header">{{__('Label.True_False_Quiz')}}</h5>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Quiz_Question')}}</label>
                                    <input name="true_false_question" type="number" value="{{$quiz_configuration['true_false_question']}}" min="0" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Manimum_Winning_Percentage')}}</label>
                                    <input name="min_true_false_percentage" type="number" value="{{$quiz_configuration['min_true_false_percentage']}}" min="0" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Winnging_Point')}}</label>
                                    <input name="true_false_win_point" type="number" value="{{$quiz_configuration['true_false_win_point']}}" min="0" class="form-control">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card custom-border-card">
                    <h5 class="card-header">{{__('Label.Daily_Quiz')}}</h5>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Quiz_Question')}}</label>
                                    <input name="daily_quiz_question" type="number" value="{{$quiz_configuration['daily_quiz_question']}}" min="0" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Manimum_Winning_Percentage')}}</label>
                                    <input name="min_daily_quiz_percentage" type="number" value="{{$quiz_configuration['min_daily_quiz_percentage']}}" min="0" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>{{__('Label.Winnging_Point')}}</label>
                                    <input name="daily_quiz_win_point" type="number" value="{{$quiz_configuration['daily_quiz_win_point']}}" min="0" class="form-control">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="pt-3 text-right">
                    <button type="button" class="btn btn-default mw-120" onclick="save_configuration()">{{__('Label.SAVE')}}</button>
                </div>
            </form>
        </div>
    </div>
@endsection

@section('pagescript')
    <script>
        function save_configuration() {
            $("#dvloader").show();
            var formData = new FormData($("#save_configuration")[0]);
            $.ajax({
                type: 'POST',
                url: '{{ route("quizConfigurationSave") }}',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function(resp) {
                    $("#dvloader").hide();
                    get_responce_message(resp, 'save_configuration', '{{ route("quizConfiguration") }}');
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $("#dvloader").hide();
                    toastr.error(errorThrown.msg, 'failed');
                }
            });
        }
    </script>
@endsection