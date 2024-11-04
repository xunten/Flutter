<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\Models\Users;

class UserTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Users::insert([
            'fullname' => "Admin",
            'username' => "Admin",
            'email' => "admin@gmail.com",
            'password' => Hash::make('00000'),
            'mobile_number' => 1234567890,
            'profile_img' => "",
            'reference_code' => Str::random(14),
            'c_date' => date('Y-m-d'),

        ]);
    }
}
