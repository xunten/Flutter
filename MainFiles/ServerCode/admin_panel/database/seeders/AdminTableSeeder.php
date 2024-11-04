<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\Models\Admin;

class AdminTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {   
        Admin::truncate();

        Admin::insert([
            'username' => "admin",
            'email' => "admin@admin.com",
            'password' => Hash::make('admin'),
            'type' => '1',
            'status' => '1',
        ]);
    }
}
