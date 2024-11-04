<div class="sidebar">
    <div class="side-head">
        <a href="{{route('dashboard')}}" style="color:#4e45b8;">
            <h3>{{ App_Name() }}</h3>
        </a>
        <button class="btn side-toggle">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </div>

    <ul class="side-menu mt-4">

        <?php $list = MenuData(); ?>

        <!-- Dashboard -->
        @if($list['dashboard'] == 1)
        <li class="side_line {{ request()->is('admin/dashboard') ? 'active' : '' }}">
            <a href="{{ route('dashboard')}}">
                <i class="fa-solid fa-house fa-2xl menu-icon"></i>
                <span>{{__('Label.Dashboard')}}</span>
            </a>
        </li>
        @endif
        <!-- Basic Settings -->
        @if($list['category'] == 1 || $list['level'] == 1 || $list['classification'] == 1 || $list['page'] == 1)
        <li class="dropdown {{ request()->routeIs('category*') ? 'active' : '' }}{{ request()->routeIs('level*') ? 'active' : '' }}{{ request()->routeIs('classification*') ? 'active' : '' }}{{ request()->routeIs('page*') ? 'active' : '' }}">
            <a class="dropdown-toggle" id="dropdownMenuClickable" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa-solid fa-gear fa-2xl menu-icon"></i>
                <span> {{__('Label.basic_setting')}} </span>
            </a>
            <ul class="dropdown-menu side-submenu {{ request()->routeIs('category*') ? 'show' : '' }}{{ request()->routeIs('level*') ? 'show' : '' }}{{ request()->routeIs('classification*') ? 'show' : '' }}{{ request()->routeIs('page*') ? 'show' : '' }}" aria-labelledby="dropdownMenuClickable">
                @if($list['category'] == 1)
                <li class="side_line {{ request()->routeIs('category*') ? 'active' : '' }}">
                    <a href="{{ route('category.index') }}" class="dropdown-item">
                        <i class="fa-solid fa-list fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Category')}} </span>
                    </a>
                </li>
                @endif
                @if($list['level'] == 1)
                <li class="side_line {{ request()->routeIs('level*') ? 'active' : '' }}">
                    <a href="{{ route('level.index') }}" class="dropdown-item">
                        <i class="fa-solid fa-signal fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Level')}} </span>
                    </a>
                </li>
                @endif
                @if($list['classification'] == 1)
                <li class="side_line {{ request()->routeIs('classification*') ? 'active' : '' }}">
                    <a href="{{ route('classification.index') }}" class="dropdown-item">
                        <i class="fa-solid fa-bars-staggered fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Classification')}} </span>
                    </a>
                </li>
                @endif
                @if($list['page'] == 1)
                <li class="side_line {{ request()->routeIs('page*') ? 'active' : '' }}">
                    <a href="{{ route('page.index') }}" class="dropdown-item">
                        <i class="fa-solid fa-book-open-reader fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Pages')}} </span>
                    </a>
                </li>
                @endif
            </ul>
        </li>
        @endif
        <!-- Users -->
        @if($list['user'] == 1)
        <li class="side_line {{ request()->routeIs('user*') ? 'active' : '' }}">
            <a href="{{ route('user.index') }}">
                <i class="fa-solid fa-users fa-2xl menu-icon"></i>
                <span> {{__('Label.Users')}} </span>
            </a>
        </li>
        @endif
        <!-- Question -->
        @if($list['pratice question'] == 1 || $list['normal question'] == 1 || $list['audio question'] == 1 || $list['video question'] == 1 || $list['true/false question'] == 1 || $list['daily quiz question'] == 1)
        <li class="dropdown {{ request()->routeIs('praticequestion*') ? 'active' : '' }}{{ request()->routeIs('normalquestion*') ? 'active' : '' }}{{ request()->routeIs('audioquestion*') ? 'active' : '' }}{{ request()->routeIs('videoquestion*') ? 'active' : '' }}{{ request()->routeIs('truefalsequestion*') ? 'active' : '' }}{{ request()->routeIs('dailyquizquestion*') ? 'active' : '' }}">
            <a class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa-solid fa-circle-question fa-2xl menu-icon"></i>
                <span> {{__('Label.Question')}} </span>
            </a>
            <ul class="dropdown-menu side-submenu {{ request()->routeIs('praticequestion*') ? 'show' : '' }}{{ request()->routeIs('normalquestion*') ? 'show' : '' }}{{ request()->routeIs('audioquestion*') ? 'show' : '' }}{{ request()->routeIs('videoquestion*') ? 'show' : '' }}{{ request()->routeIs('truefalsequestion*') ? 'show' : '' }}{{ request()->routeIs('dailyquizquestion*') ? 'show' : '' }}">
                @if($list['pratice question'] == 1)
                <li class="side_line {{ request()->routeIs('praticequestion*') ? 'active' : '' }}">
                    <a href="{{ route('praticequestion.index') }}" class="dropdown-item">
                        <i class="fa-regular fa-circle-question fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Pratice_Question')}} </span>
                    </a>
                </li>
                @endif
                @if($list['normal question'] == 1)
                <li class="side_line {{ request()->routeIs('normalquestion*') ? 'active' : '' }}">
                    <a href="{{ route('normalquestion.index') }}" class="dropdown-item">
                        <i class="fa-regular fa-circle-question fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Normal_Question')}} </span>
                    </a>
                </li>
                @endif
                @if($list['audio question'] == 1)
                <li class="side_line {{ request()->routeIs('audioquestion*') ? 'active' : '' }}">
                    <a href="{{ route('audioquestion.index') }}" class="dropdown-item">
                        <i class="fa-regular fa-circle-question fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Audio_Question')}} </span>
                    </a>
                </li>
                @endif
                @if($list['video question'] == 1)
                <li class="side_line {{ request()->routeIs('videoquestion*') ? 'active' : '' }}">
                    <a href="{{ route('videoquestion.index') }}" class="dropdown-item">
                        <i class="fa-regular fa-circle-question fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Video_Question')}} </span>
                    </a>
                </li>
                @endif
                @if($list['true/false question'] == 1)
                <li class="side_line {{ request()->routeIs('truefalsequestion*') ? 'active' : '' }}">
                    <a href="{{ route('truefalsequestion.index') }}" class="dropdown-item">
                        <i class="fa-regular fa-circle-question fa-2xl submenu-icon"></i>
                        <span> {{__('Label.true_false_question')}} </span>
                    </a>
                </li>
                @endif
                @if($list['daily quiz question'] == 1)
                <li class="side_line {{ request()->routeIs('dailyquizquestion*') ? 'active' : '' }}">
                    <a href="{{ route('dailyquizquestion.index') }}" class="dropdown-item">
                        <i class="fa-regular fa-circle-question fa-2xl submenu-icon"></i>
                        <span> {{__('Label.daily_quiz_question')}} </span>
                    </a>
                </li>
                @endif
            </ul>
        </li>
        @endif
        <!-- Leaderboard -->
        @if($list['pratice leaderboard'] == 1 || $list['normal leaderboard'] == 1 || $list['audio leaderboard'] == 1 || $list['video leaderboard'] == 1 || $list['true/false leaderboard'] == 1 || $list['daily quiz leaderboard'] == 1)
        <li class="dropdown {{ request()->routeIs('praticeleaderboard') ? 'active' : '' }}{{ request()->routeIs('normalleaderboard') ? 'active' : '' }}{{ request()->routeIs('audioleaderboard') ? 'active' : '' }}{{ request()->routeIs('videoleaderboard') ? 'active' : '' }}{{ request()->routeIs('truefalseleaderboard') ? 'active' : '' }}{{ request()->routeIs('dailyquizleaderboard') ? 'active' : '' }}">
            <a class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa-solid fa-square-poll-vertical fa-2xl menu-icon"></i>
                <span> {{__('Label.Leaderboard')}} </span>
            </a>
            <ul class="dropdown-menu side-submenu {{ request()->routeIs('praticeleaderboard') ? 'show' : '' }}{{ request()->routeIs('normalleaderboard') ? 'show' : '' }}{{ request()->routeIs('audioleaderboard') ? 'show' : '' }}{{ request()->routeIs('videoleaderboard') ? 'show' : '' }}{{ request()->routeIs('truefalseleaderboard') ? 'show' : '' }}{{ request()->routeIs('dailyquizleaderboard') ? 'show' : '' }}">
                @if($list['pratice leaderboard'] == 1)
                <li class="side_line {{ request()->routeIs('praticeleaderboard') ? 'active' : '' }}">
                    <a href="{{ route('praticeleaderboard') }}" class="dropdown-item">
                        <i class="fa-solid fa-chart-line fa-xl submenu-icon"></i>
                        <span>{{__('Label.Pratice_Leaderboard')}}</span>
                    </a>
                </li>
                @endif
                @if($list['normal leaderboard'] == 1)
                <li class="side_line {{ request()->routeIs('normalleaderboard') ? 'active' : '' }}">
                    <a href="{{ route('normalleaderboard') }}" class="dropdown-item">
                        <i class="fa-solid fa-chart-line fa-xl submenu-icon"></i>
                        <span>{{__('Label.Normal_Leaderboard')}}</span>
                    </a>
                </li>
                @endif
                @if($list['audio leaderboard'] == 1)
                <li class="side_line {{ request()->routeIs('audioleaderboard') ? 'active' : '' }}">
                    <a href="{{ route('audioleaderboard') }}" class="dropdown-item">
                        <i class="fa-solid fa-chart-line fa-xl submenu-icon"></i>
                        <span>{{__('Label.Audio_Leaderboard')}}</span>
                    </a>
                </li>
                @endif
                @if($list['video leaderboard'] == 1)
                <li class="side_line {{ request()->routeIs('videoleaderboard') ? 'active' : '' }}">
                    <a href="{{ route('videoleaderboard') }}" class="dropdown-item">
                        <i class="fa-solid fa-chart-line fa-xl submenu-icon"></i>
                        <span>{{__('Label.Video_Leaderboard')}}</span>
                    </a>
                </li>
                @endif
                @if($list['true/false leaderboard'] == 1)
                <li class="{{ request()->routeIs('truefalseleaderboard') ? 'active' : '' }}">
                    <a href="{{ route('truefalseleaderboard') }}" class="dropdown-item">
                        <i class="fa-solid fa-chart-line fa-lg submenu-icon"></i>
                        <span>{{__('Label.true_false_leaderboard')}}</span>
                    </a>
                </li>
                @endif
                @if($list['daily quiz leaderboard'] == 1)
                <li class="{{ request()->routeIs('dailyquizleaderboard') ? 'active' : '' }}">
                    <a href="{{ route('dailyquizleaderboard') }}" class="dropdown-item">
                        <i class="fa-solid fa-chart-line fa-lg submenu-icon"></i>
                        <span> {{__('Label.Daily_Quiz_Leaderboard')}} </span>
                    </a>
                </li>
                @endif
            </ul>
        </li>
        @endif
        <!-- Contest -->
        @if($list['contest list'] == 1 || $list['contest question'] == 1)
        <li class="dropdown {{ request()->routeIs('contest*') ? 'active' : '' }}">
            <a class="dropdown-toggle" data-toggle="dropdown" id="dropdownMenuClickable" aria-haspopup="true" data-auto-close="false" aria-expanded="false">
                <i class="fa-solid fa-list-check fa-2xl menu-icon"></i>
                <span> {{__('Label.Contest')}} </span>
            </a>
            <ul class="dropdown-menu side-submenu {{ request()->routeIs('contest*') ? 'show' : '' }}" aria-labelledby="dropdownMenuClickable">
                @if($list['contest list'] == 1)
                <li class="side_line {{ request()->routeIs('contests*') ? 'active' : '' }}{{ request()->routeIs('contestleaderboard') ? 'active' : '' }}">
                    <a href="{{ route('contests.index') }}" class="dropdown-item">
                        <i class="fa-solid fa-list-ol fa-xl submenu-icon"></i>
                        <span> {{__('Label.Contest List')}} </span>
                    </a>
                </li>
                @endif
                @if($list['contest question'] == 1)
                <li class="side_line {{ request()->routeIs('contestquestion*') ? 'active' : '' }}">
                    <a href="{{ route('contestquestion.index') }}" class="dropdown-item">
                        <i class="fa-regular fa-circle-question fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Contest Question')}} </span>
                    </a>
                </li>
                @endif
            </ul>
        </li>
        @endif
        <!-- One VS One -->
        <!-- @if($list['one to one list'] == 1 || $list['one to one leaderboard'] == 1)
        <li class="dropdown {{ request()->is('admin/one_to_one') ? 'active' : '' }}{{ request()->is('admin/one_to_oneleaderboard') ? 'active' : '' }}">
            <a class="dropdown-toggle" data-toggle="dropdown" id="dropdownMenuClickable" aria-haspopup="true" data-auto-close="false" aria-expanded="false">
                <img class="menu-icon" src="{{ asset('assets/imgs/one_to_one.png') }}" alt="" />
                <span> {{__('Label.One VS One')}} </span>
            </a>
            <ul class="dropdown-menu side-submenu {{ request()->is('admin/one_to_one') ? 'show' : '' }}{{ request()->is('admin/one_to_oneleaderboard') ? 'show' : '' }}" aria-labelledby="dropdownMenuClickable">
                @if($list['one to one list'] == 1)
                <li class="side_line {{ request()->is('admin/one_to_one') ? 'active' : '' }}">
                    <a href="{{ route('one_to_one_challenge') }}" class="dropdown-item">
                        <img class="submenu-icon mr-2" src="{{ asset('assets/imgs/session.png') }}" alt="" />
                        <span> {{__('Label.Challenge List')}} </span>
                    </a>
                </li>
                @endif
                @if($list['one to one leaderboard'] == 1)
                <li class="side_line {{ request()->is('admin/one_to_oneleaderboard') ? 'active' : '' }}">
                    <a href="{{ route('one_to_one_leaderboard') }}" class="dropdown-item">
                        <img class="submenu-icon mr-2" src="{{ asset('assets/imgs/leaderboard.png') }}" alt="" />
                        <span> {{__('Label.Leaderboard')}} </span>
                    </a>
                </li>
                @endif
            </ul>
        </li>
        @endif -->
        <!-- Withdrawal -->
        @if($list['withdrawal'] == 1)
        <li class="side_line {{ request()->routeIs('withdrawal*') ? 'active' : '' }}">
            <a href="{{ route('withdrawal.index') }}">
                <i class="fa-solid fa-right-left fa-2xl menu-icon"></i>
                <span> {{__('Label.Withdrawal')}} </span>
            </a>
        </li>
        @endif
        <!-- Notification -->
        @if($list['notification'] == 1)
        <li class="side_line {{ request()->routeIs('notification*') ? 'active' : '' }}">
            <a href="{{ route('notification.index') }}">
                <i class="fa-solid fa-bell fa-2xl menu-icon"></i>
                <span> {{__('Label.Notification')}} </span>
            </a>
        </li>
        @endif
        <!-- Subscription -->
        @if($list['package'] == 1 || $list['transaction'] == 1 || $list['payment'] == 1)
        <li class="dropdown {{ request()->routeIs('package*') ? 'active' : '' }}{{ request()->routeIs('transaction*') ? 'active' : '' }}{{ request()->routeIs('payment*') ? 'active' : '' }}">
            <a class="dropdown-toggle" id="dropdownMenuClickable" data-toggle="dropdown" aria-haspopup="true" data-auto-close="false" aria-expanded="false">
                <i class="fa-solid fa-money-bill fa-2xl menu-icon"></i>
                <span> {{__('Label.Subscription')}} </span>
            </a>
            <ul class="dropdown-menu side-submenu {{ request()->routeIs('package*') ? 'show' : '' }}{{ request()->routeIs('transaction*') ? 'show' : '' }}{{ request()->routeIs('payment*') ? 'show' : '' }}" aria-labelledby="dropdownMenuClickable">
                @if($list['package'] == 1)
                <li class="side_line {{ request()->routeIs('package*') ? 'active' : '' }}">
                    <a href="{{ route('package.index') }}" class="dropdown-item">
                        <i class="fa-solid fa-box-archive fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Packages')}} </span>
                    </a>
                </li>
                @endif
                @if($list['transaction'] == 1)
                <li class="side_line {{ request()->routeIs('transaction*') ? 'active' : '' }}">
                    <a href="{{ route('transaction.index') }}" class="dropdown-item">
                        <i class="fa-solid fa-wallet fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Transaction')}} </span>
                    </a>
                </li>
                @endif
                @if($list['payment'] == 1)
                <li class="side_line {{ request()->routeIs('payment*') ? 'active' : '' }}">
                    <a href="{{ route('payment.index') }}" class="dropdown-item">
                        <i class="fa-solid fa-money-bill-wave fa-2xl submenu-icon"></i>
                        <span> {{__('Label.Payment')}} </span>
                    </a>
                </li>
                @endif
            </ul>
        </li>
        @endif
        <!-- Settings -->
        @if($list['general setting'] == 1 || $list['earning setting'] == 1 || $list['quiz configuration'] == 1)
        <li class="dropdown {{ request()->routeIs('setting*') ? 'active' : '' }}{{ request()->routeIs('earningsetting*') ? 'active' : '' }}{{ request()->routeIs('quizConfiguration*') ? 'active' : '' }}{{ request()->routeIs('smtp*') ? 'active' : '' }}">
            <a class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa-solid fa-gear fa-2xl menu-icon"></i>
                <span> {{__('Label.Setting')}} </span>
            </a>
            <ul class="dropdown-menu side-submenu {{ request()->routeIs('setting*') ? 'show' : '' }}{{ request()->routeIs('earningsetting*') ? 'show' : '' }}{{ request()->routeIs('quizConfiguration*') ? 'show' : '' }}{{ request()->routeIs('smtp*') ? 'show' : '' }}">
                @if($list['general setting'] == 1)
                <li class="side_line {{ request()->routeIs('setting*') ? 'active' : '' }}{{ request()->routeIs('smtp*') ? 'active' : '' }}">
                    <a href="{{ route('setting') }}" class="dropdown-item">
                        <i class="fa-solid fa-gears fa-2xl submenu-icon"></i>
                        <span> {{__('Label.general_setting')}} </span>
                    </a>
                </li>
                @endif
                @if($list['earning setting'] == 1)
                <li class="side_line {{ request()->routeIs('earningsetting*') ? 'active' : '' }}">
                    <a href="{{ route('earningsetting') }}" class="dropdown-item">
                        <i class="fa-solid fa-screwdriver-wrench fa-2xl submenu-icon"></i>
                        <span>{{__('Label.Earning Setting')}}</span>
                    </a>
                </li>
                @endif
                @if($list['quiz configuration'] == 1)
                <li class="side_line {{ request()->routeIs('quizConfiguration*') ? 'active' : '' }}">
                    <a href="{{ route('quizConfiguration') }}" class="dropdown-item">
                        <i class="fa-solid fa-sliders fa-2xl submenu-icon"></i>
                        <span>{{__('Label.quiz_configuration')}}</span>
                    </a>
                </li>
                @endif
            </ul>
        </li>
        @endif
        <li>
            <a href="{{ route('adminLogout') }}" onclick="event.preventDefault(); document.getElementById('logout-form').submit();">
                <i class="fa-solid fa-arrow-right-from-bracket fa-2xl menu-icon"></i>
                <span>{{__('Label.Logout')}}</span>
            </a>

            <form id="logout-form" action="{{ route('adminLogout') }}" method="GET" class="d-none">
                @csrf
            </form>
        </li>
    </ul>
</div>