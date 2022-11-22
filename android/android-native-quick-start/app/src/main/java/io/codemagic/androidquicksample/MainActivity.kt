package io.codemagic.androidquicksample

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import io.codemagic.androidquicksample.ui.theme.CodemagicAndroidQuickStartSampleTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            CodemagicAndroidQuickStartSampleTheme {
                // A surface container using the 'background' color from the theme
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colors.background) {
                    Greeting()
                }
            }
        }
    }
}

@Composable
fun Greeting() {
    Surface(color = Color(0,111,243)) {
        Text(text = "Hello from Codemagic!", modifier = Modifier.padding(24.dp), color = Color.White)
    }
}


@Preview(showBackground = true)
@Composable
fun DefaultPreview() {
    CodemagicAndroidQuickStartSampleTheme {
        Greeting()
    }
}