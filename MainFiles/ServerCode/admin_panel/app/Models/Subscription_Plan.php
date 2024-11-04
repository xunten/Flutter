<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Subscription_Plan extends Model
{
    use HasFactory;

    protected $table = 'tbl_package';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'name' => 'string',
        'price' => 'integer',
        'image' => 'string',
        'currency_type' => 'string',
        'point' => 'string',
        'android_product_package' => 'string',
        'ios_product_package' => 'string',
        'is_delete' => 'integer',
        'status' => 'integer',
    ];
}
