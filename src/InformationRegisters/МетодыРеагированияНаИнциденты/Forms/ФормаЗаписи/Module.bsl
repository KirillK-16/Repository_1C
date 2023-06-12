&НаСервереБезКонтекста
Процедура ПоместитьДанныеВЗапись(АдресДанных, ИмяФайла, ТипИнцидента, Период)
	
	Данные = ПолучитьИзВременногоХранилища(АдресДанных);
	
	Запись = РегистрыСведений.МетодыРеагированияНаИнциденты.СоздатьМенеджерЗаписи();
	Запись.Период = Период;
	Запись.ТипИнцидента = ТипИнцидента;
	Запись.Прочитать();
    Запись.Период = Период;
	Запись.ТипИнцидента = ТипИнцидента;
	Запись.ИмяФайла = ИмяФайла;
	Запись.Файл = Новый ХранилищеЗначения(Данные, Новый СжатиеДанных(9));
	Запись.Записать(ИСТИНА);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДобавлениеФайла(Результат, Параметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Модифицированность Тогда
		ЭтотОбъект.Записать();
	КонецЕсли;
	
	ДиалогОткр = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткр.МножественныйВыбор = ЛОЖЬ;
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьДобавлениеФайлаЗавершение", ЭтотОбъект);
	ДиалогОткр.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДобавлениеФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		Файл = Новый Файл(ВыбранныеФайлы[0]);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьДобавлениеФайлаЗавершениеНачатьПроверкуСуществованияЗавершение", ЭтотОбъект, Файл);
		Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДобавлениеФайлаЗавершениеНачатьПроверкуСуществованияЗавершение(Существует, ДополнительныеПараметры) Экспорт
	
	Если Существует Тогда
		Файл = ДополнительныеПараметры;
		Данные = Новый ДвоичныеДанные(Файл.ПолноеИмя);
		Адрес = ПоместитьВоВременноеХранилище(Данные, новый УникальныйИдентификатор());
		ПоместитьДанныеВЗапись(Адрес, Файл.Имя,  Запись.ТипИнцидента, Запись.Период);
		Прочитать();
		
		ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.МетодыРеагированияНаИнциденты"));
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ВыполнитьУдалениеФайлаНаСервере() Экспорт
	Запись2 = РегистрыСведений.МетодыРеагированияНаИнциденты.СоздатьМенеджерЗаписи();
	Запись2.Период = Запись.Период;
	Запись2.ТипИнцидента = Запись.ТипИнцидента;
	Запись2.Прочитать();
	Запись2.ИмяФайла = "";
	Запись2.Файл = Новый ХранилищеЗначения(неопределено);
	Запись2.Записать(ИСТИНА);
	Прочитать();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьУдалениеФайла(Результат, Параметры) Экспорт
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Модифицированность Тогда
		ЭтотОбъект.Записать();
	КонецЕсли;
	
	ВыполнитьУдалениеФайлаНаСервере();
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.МетодыРеагированияНаИнциденты"));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Команда)
	
	Если ЭтотОбъект.Модифицированность Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ВыполнитьДобавлениеФайла", ЭтотОбъект),"Необходимо записать данные формы перед присоединением файла. Записать?", РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьДобавлениеФайла(КодВозвратаДиалога.Да, неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайл(Команда)
	
	Если ЭтотОбъект.Модифицированность Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ВыполнитьУдалениеФайла", ЭтотОбъект),"Необходимо записать данные формы перед удалением файла. Записать?", РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьУдалениеФайла(КодВозвратаДиалога.Да, неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеФайлаВАдрес() 
	
	ЗаписьПолная = РеквизитФормыВЗначение("Запись");
	Возврат ПоместитьВоВременноеХранилище(ЗаписьПолная.Файл.Получить(),Новый УникальныйИдентификатор());
	
КонецФункции

&НаКлиенте
Процедура СкачатьФайл(Команда)
	
	ДиалогСохр = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	Ф = Новый Файл(Запись.ИмяФайла); ДиалогСохр.Расширение = Сред(Ф.Расширение,2,999);
	ДиалогСохр.ПолноеИмяФайла = Запись.ИмяФайла;
	ОписаниеОповещения = Новый ОписаниеОповещения("СкачатьФайлЗавершение", ЭтотОбъект);
	ДиалогСохр.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьФайлЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		АдресДанных = ПолучитьДанныеФайлаВАдрес();
		Данные = ПолучитьИзВременногоХранилища(АдресДанных);
		Данные.Записать(ВыбранныеФайлы[0]);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Элементы.ФормаСкачатьФайл.Доступность = НЕ ПустаяСтрока(ТекущийОбъект.ИмяФайла);
	Элементы.ФормаУдалитьФайл.Доступность = Элементы.ФормаСкачатьФайл.Доступность;
	Элементы.ФормаДобавитьФайл.Доступность = НЕ Элементы.ФормаУдалитьФайл.Доступность;
КонецПроцедуры
