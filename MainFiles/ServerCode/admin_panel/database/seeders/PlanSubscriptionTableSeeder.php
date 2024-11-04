<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Str;
use App\Models\Subscription_Plan;

class PlanSubscriptionTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Subscription_Plan::insert([
            'name' => "Plan 1",
            'price' => 100,
            'image' =>  "",
            'currency_type' => '$',
            'coin' => 1000,
            'android_product_package' => "Product Package",
            'ios_product_package' => "Product Package",
        ]);
    }
}
