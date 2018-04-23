package com.github.wuxudong.rncharts.markers;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v4.content.res.ResourcesCompat;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.github.mikephil.charting.charts.Chart;
import com.github.mikephil.charting.components.MarkerView;
import com.github.mikephil.charting.data.CandleEntry;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.utils.MPPointF;
import com.github.mikephil.charting.utils.Utils;
import com.github.wuxudong.rncharts.R;

import java.util.List;
import java.util.Map;

public class RNRectangleMarkerView extends MarkerView {

    private TextView tvContent;
    private View shadowContent;

    private Drawable backgroundLeft = ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_left, null);
    private Drawable background = ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker, null);
    private Drawable backgroundRight = ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_right, null);

    private Drawable backgroundTopLeft = ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_top_left, null);
    private Drawable backgroundTop = ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_top, null);
    private Drawable backgroundTopRight = ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_top_right, null);


    private Drawable shadow =  ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_shadow, null);
    private Drawable shadowTop =  ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_top_shadow, null);
    private Drawable shadowTopLeft =  ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_top_left_shadow, null);
    private Drawable shadowLeft =  ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_left_shadow, null);
    private Drawable shadowRight =  ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_right_shadow, null);
    private Drawable shadowTopRight =  ResourcesCompat.getDrawable(getResources(), R.drawable.rectangle_marker_top_right_shadow, null);

    private int digits = 0;

    private float mVerticalOffset = 0;

    public RNRectangleMarkerView(Context context) {
        super(context, R.layout.rectangle_marker);

        tvContent = (TextView) findViewById(R.id.rectangle_tvContent);
        shadowContent = (View) findViewById(R.id.rectangle_tvContent_shadow);
    }

    public void setDigits(int digits) {
        this.digits = digits;
    }

    public void setVerticalOffset(float mVerticalOffset) {
        this.mVerticalOffset = mVerticalOffset;
    }

    @Override
    public void refreshContent(Entry e, Highlight highlight) {
        String text;

        if (e instanceof CandleEntry) {
            CandleEntry ce = (CandleEntry) e;
            text = Utils.formatNumber(ce.getClose(), digits, false);
        } else {
            text = Utils.formatNumber(e.getY(), digits, false);
        }

        if (e.getData() instanceof Map) {
            if (((Map) e.getData()).containsKey("marker")) {

                Object marker = ((Map) e.getData()).get("marker");
                text = marker.toString();

                if (highlight.getStackIndex() != -1 && marker instanceof List) {
                    text = ((List) marker).get(highlight.getStackIndex()).toString();
                }

            }
        }

        if (TextUtils.isEmpty(text)) {
            tvContent.setVisibility(INVISIBLE);
        } else {
            tvContent.setText(text);
            tvContent.setVisibility(VISIBLE);
        }
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            tvContent.setClipToOutline(true);
            tvContent.setElevation(8);
        }

        super.refreshContent(e, highlight);
    }

    @Override
    public MPPointF getOffset() {
        return new MPPointF(-(getWidth() / 2), -getHeight());
    }

    @Override
    public MPPointF getOffsetForDrawingAtPoint(float posX, float posY) {

        MPPointF offset = getOffset();

        MPPointF offset2 = new MPPointF();


        offset2.x = offset.x;
        offset2.y = offset.y - mVerticalOffset;

        Chart chart = getChartView();

        float width = getWidth();

        if (posX + offset2.x < 0) {
            offset2.x = -20;

            if (posY + offset2.y < 0) {
                offset2.y = mVerticalOffset;
                tvContent.setBackground(backgroundTopLeft);
                shadowContent.setBackground(shadowTopLeft);

            } else {
                tvContent.setBackground(backgroundLeft);
                shadowContent.setBackground(shadowLeft);
            }

        } else if (chart != null && posX + width + offset2.x > chart.getWidth()) {
            offset2.x = -width + 20;

            if (posY + offset2.y < 0) {
                offset2.y = mVerticalOffset;
                tvContent.setBackground(backgroundTopRight);
                shadowContent.setBackground(shadowTopRight);
            } else {
                tvContent.setBackground(backgroundRight);
                shadowContent.setBackground(shadowRight);
            }
        } else {
            if (posY + offset2.y < 0) {
                offset2.y = mVerticalOffset;
                tvContent.setBackground(backgroundTop);
                shadowContent.setBackground(shadowTop);
            } else {
                tvContent.setBackground(background);
                shadowContent.setBackground(shadow);
            }
        }

        return offset2;
    }

    public TextView getTvContent() {
        return tvContent;
    }

}

