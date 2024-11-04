<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Earnpoint_Setting;

class EarnpointSettingTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
      Earnpoint_Setting::truncate();
      $data =  [
        ['key' => 'Level', 'value' => '100', 'type' => '1'],
        ['key' => 'Registration', 'value' => '100', 'type' => '2'],
        ['key' => 'ReferUser', 'value' => '200', 'type' => '3'],          
      ];
      Earnpoint_Setting::insert($data);
    }
}
