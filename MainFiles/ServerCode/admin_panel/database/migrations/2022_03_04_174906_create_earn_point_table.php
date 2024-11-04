<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\Earn_point;

class CreateEarnPointTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('earn_point', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('key');
            $table->string('value');
            $table->integer('type');
            $table->integer('point_type')->default(1)->comment('1-Spin wheel , 2-Daily Login point , 3-sget free coin');
            $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'));
        });
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

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('earn_point');
    }
}
