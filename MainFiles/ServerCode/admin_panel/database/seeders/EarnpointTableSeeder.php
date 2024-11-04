<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Earn_point;

class EarnpointTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Earn_point::truncate();
        $data =  [
            // Spin Wheel Point
            ['key' => '1', 'value' => '100', 'type' => '1', 'point_type' => '1'],
            ['key' => '2', 'value' => '200', 'type' => '2', 'point_type' => '1'],
            ['key' => '3', 'value' => '400', 'type' => '3', 'point_type' => '1'],
            ['key' => '4', 'value' => '500', 'type' => '4', 'point_type' => '1'],
            ['key' => '5', 'value' => '700', 'type' => '5', 'point_type' => '1'],
            ['key' => '6', 'value' => '800', 'type' => '6', 'point_type' => '1'],
            // Daily Login Point
            ['key' => 'Day-1', 'value' => '100', 'type' => '7', 'point_type' => '2'],
            ['key' => 'Day-2', 'value' => '200', 'type' => '8', 'point_type' => '2'],
            ['key' => 'Day-3', 'value' => '300', 'type' => '9', 'point_type' => '2'],
            ['key' => 'Day-4', 'value' => '400', 'type' => '10', 'point_type' => '2'],
            ['key' => 'Day-5', 'value' => '500', 'type' => '11', 'point_type' => '2'],
            ['key' => 'Day-6', 'value' => '600', 'type' => '12', 'point_type' => '2'],
            ['key' => 'Day-7', 'value' => '700', 'type' => '13', 'point_type' => '2'],
            // Get Free Coin Point
            ['key' => 'free-coin', 'value' => '10', 'type' => '14', 'point_type' => '3'],
        ];
        Earn_point::insert($data);
    }
}
