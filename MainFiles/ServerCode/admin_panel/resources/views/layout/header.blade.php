<header class="header">
    <div class="title-control">
        <button class="btn side-toggle">
            <span></span>
            <span></span>
            <span></span>
        </button>

        <a href="{{route('dashboard')}}" style="color:#4e45b8;" class="side-logo">
            <h3>{{ App_Name()}}</h3>
        </a>
        <h1 class="page-title">@yield('page_title')</h1>
    </div>
    <div class="head-control">
        <!-- Setting -->
        <a href="{{ route('setting') }}" class="btn" title="Setting">
            <i class="fa-solid fa-gear fa-2xl" style="color: #4e45b8;"></i>
        </a>
        <!-- Language -->
        <!-- <div class="dropdown dropright">
          <a href="#" class="btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Language">
            <i class="fa-solid fa-globe fa-2xl" style="color: #4e45b8;"></i>
          </a>
          <div class="dropdown-menu p-2 mt-2" aria-labelledby="dropdownMenuLink">
            @foreach (lang() as $value) 
              <a class="dropdown-item {{ $value['status'] == "1"  ? 'active' : ''}} "  href="{{route('language',$value->id)}}">{{$value->language}}</a>
            @endforeach
          </div>
        </div> -->
        <!-- Profile -->
        <div class="dropdown dropright">
            <a href="#" class="btn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa-solid fa-user fa-2xl" style="color: #4e45b8;" class="avatar-img"></i>
            </a>

            <div class="dropdown-menu p-2 mt-2" aria-labelledby="dropdownMenuLink">
                <div>
                    <?php $data = adminData(); if($data){echo $data['username'] ?: "";} ?>
                    <br><hr class="mt-2">
                    <?php $data = adminData(); if($data){echo $data['email'] ?: "";} ?>
                </div><hr class="mt-2">
                <a class="dropdown-item" href="{{ route('adminLogout') }}" style="color:#4E45B8;">
                    <span><i class="fa-solid fa-arrow-right-from-bracket fa-xl mr-2"></i></span>
                    {{__('Label.Logout')}}
                </a>
            </div>
        </div>
    </div>
</header>